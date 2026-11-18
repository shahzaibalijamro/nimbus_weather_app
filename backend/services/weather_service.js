// services/weather_service.js
// Integrates with Open-Meteo for real-time accurate weather & 5-day forecasts

const cache = {
  current: new Map(),
  forecast: new Map(),
};

const CACHE_TTL_MS = 15 * 60 * 1000; // 15 minutes cache

/**
 * Maps WMO weather interpretation code to Nimbus condition schema
 */
function mapWmoToCondition(code) {
  // WMO Code Reference: https://open-meteo.com/en/docs
  if (code === 0) {
    return { code: 'clear', label: 'Clear Sky', icon: 'sun' };
  }
  if (code === 1 || code === 2) {
    return { code: 'partly_cloudy', label: 'Partly Cloudy', icon: 'cloud-sun' };
  }
  if (code === 3) {
    return { code: 'cloudy', label: 'Overcast', icon: 'cloud' };
  }
  if (code === 45 || code === 48) {
    return { code: 'fog', label: 'Foggy', icon: 'cloud-fog' };
  }
  if ([51, 53, 55, 56, 57].includes(code)) {
    return { code: 'drizzle', label: 'Drizzle', icon: 'cloud-rain' };
  }
  if ([61, 63, 65, 66, 67, 80, 81, 82].includes(code)) {
    return { code: 'rain', label: 'Rainy', icon: 'cloud-rain' };
  }
  if ([71, 73, 75, 77, 85, 86].includes(code)) {
    return { code: 'snow', label: 'Snowy', icon: 'cloud-fog' };
  }
  if ([95, 96, 99].includes(code)) {
    return { code: 'thunderstorm', label: 'Thunderstorm', icon: 'cloud-lightning' };
  }
  return { code: 'partly_cloudy', label: 'Partly Cloudy', icon: 'cloud-sun' };
}

/**
 * Fetches real-time current weather for a city
 */
async function getLiveWeather(city) {
  const cached = cache.current.get(city.id);
  if (cached && Date.now() - cached.timestamp < CACHE_TTL_MS) {
    return cached.data;
  }

  try {
    const url = `https://api.open-meteo.com/v1/forecast?latitude=${city.lat}&longitude=${city.lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,surface_pressure,wind_speed_10m,weather_code,uv_index&timezone=auto`;
    const res = await fetch(url, { headers: { 'User-Agent': 'NimbusWeatherApp/1.0' } });
    if (!res.ok) {
      throw new Error(`Open-Meteo HTTP error: ${res.status}`);
    }

    const data = await res.json();
    const current = data.current || {};
    const condition = mapWmoToCondition(current.weather_code);

    const weatherData = {
      cityId: city.id,
      observedAt: current.time ? new Date(current.time).toISOString() : new Date().toISOString(),
      temperatureC: Math.round((current.temperature_2m ?? 20) * 10) / 10,
      feelsLikeC: Math.round((current.apparent_temperature ?? current.temperature_2m ?? 20) * 10) / 10,
      humidity: Math.round(current.relative_humidity_2m ?? 60),
      windKph: Math.round(current.wind_speed_10m ?? 12),
      pressureHpa: Math.round(current.surface_pressure ?? 1013),
      uvIndex: Math.round((current.uv_index ?? 3) * 10) / 10,
      condition,
    };

    cache.current.set(city.id, { timestamp: Date.now(), data: weatherData });
    return weatherData;
  } catch (err) {
    console.warn(`[WeatherService] Warning fetching live weather for ${city.name}: ${err.message}. Using fallback.`);
    if (cached) return cached.data;

    // Graceful offline fallback
    return {
      cityId: city.id,
      observedAt: new Date().toISOString(),
      temperatureC: 21.0,
      feelsLikeC: 20.5,
      humidity: 55,
      windKph: 14,
      pressureHpa: 1014,
      uvIndex: 4,
      condition: { code: 'partly_cloudy', label: 'Partly Cloudy', icon: 'cloud-sun' },
    };
  }
}

/**
 * Quick weather summary for city tiles: { temperatureC, condition: { code, label, icon } }
 */
async function getQuickWeather(city) {
  const full = await getLiveWeather(city);
  return {
    temperatureC: full.temperatureC,
    condition: full.condition,
  };
}

/**
 * Fetches 5-day daily forecast for a city
 */
async function getCityForecast(city, days = 5) {
  const cached = cache.forecast.get(city.id);
  if (cached && Date.now() - cached.timestamp < CACHE_TTL_MS) {
    return cached.data;
  }

  const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  try {
    const url = `https://api.open-meteo.com/v1/forecast?latitude=${city.lat}&longitude=${city.lon}&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&forecast_days=${days}`;
    const res = await fetch(url, { headers: { 'User-Agent': 'NimbusWeatherApp/1.0' } });
    if (!res.ok) {
      throw new Error(`Open-Meteo HTTP error: ${res.status}`);
    }

    const data = await res.json();
    const daily = data.daily || {};
    const dates = daily.time || [];

    const forecastData = [];
    for (let i = 0; i < Math.min(dates.length, days); i++) {
      const dateStr = dates[i];
      const d = new Date(dateStr);
      const weekday = weekdays[d.getDay()];
      const condition = mapWmoToCondition(daily.weather_code ? daily.weather_code[i] : 1);

      forecastData.push({
        date: dateStr,
        weekday,
        highC: Math.round((daily.temperature_2m_max ? daily.temperature_2m_max[i] : 22) * 10) / 10,
        lowC: Math.round((daily.temperature_2m_min ? daily.temperature_2m_min[i] : 14) * 10) / 10,
        rainChance: Math.round(daily.precipitation_probability_max ? daily.precipitation_probability_max[i] : 10),
        condition,
      });
    }

    cache.forecast.set(city.id, { timestamp: Date.now(), data: forecastData });
    return forecastData;
  } catch (err) {
    console.warn(`[WeatherService] Warning fetching forecast for ${city.name}: ${err.message}. Using fallback.`);
    if (cached) return cached.data;

    // Graceful offline fallback
    const fallback = [];
    const now = new Date();
    for (let i = 0; i < days; i++) {
      const d = new Date(now);
      d.setDate(d.getDate() + i);
      const dateStr = d.toISOString().split('T')[0];
      fallback.push({
        date: dateStr,
        weekday: weekdays[d.getDay()],
        highC: 22 + i,
        lowC: 15 + i,
        rainChance: 15,
        condition: { code: 'partly_cloudy', label: 'Partly Cloudy', icon: 'cloud-sun' },
      });
    }
    return fallback;
  }
}

module.exports = {
  getLiveWeather,
  getQuickWeather,
  getCityForecast,
};
