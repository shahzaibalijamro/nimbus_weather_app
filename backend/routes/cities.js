// routes/cities.js
const express = require('express');
const router = express.Router();
const db = require('../db');
const weatherService = require('../services/weather_service');

// GET /api/v1/cities/regions
router.get('/regions', async (req, res) => {
  try {
    const regions = await db.getRegions();
    return res.status(200).json({ data: regions });
  } catch (err) {
    console.error('[Cities] Regions error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/v1/cities
router.get('/', async (req, res) => {
  try {
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 8;
    const search = req.query.search;
    const region = req.query.region;

    const { cities, meta } = await db.getCities({ region, search, page, limit });

    // Attach live weather to each city in parallel
    const citiesWithWeather = await Promise.all(
      cities.map(async city => {
        const weather = await weatherService.getQuickWeather(city);
        return {
          id: city.id,
          name: city.name,
          country: city.country,
          region: city.region,
          tagline: city.tagline,
          population: city.population,
          weather,
        };
      })
    );

    return res.status(200).json({
      data: citiesWithWeather,
      meta,
    });
  } catch (err) {
    console.error('[Cities] List error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/v1/cities/:id
router.get('/:id', async (req, res) => {
  try {
    const city = await db.getCityById(req.params.id);
    if (!city) {
      return res.status(404).json({ message: 'City not found' });
    }

    return res.status(200).json({
      data: {
        id: city.id,
        name: city.name,
        country: city.country,
        region: city.region,
        tagline: city.tagline,
        population: city.population,
        coordinates: {
          lat: city.lat,
          lon: city.lon,
        },
        timezone: city.timezone,
      },
    });
  } catch (err) {
    console.error('[Cities] Get city error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/v1/cities/:id/weather
router.get('/:id/weather', async (req, res) => {
  try {
    const city = await db.getCityById(req.params.id);
    if (!city) {
      return res.status(404).json({ message: 'City not found' });
    }

    const weather = await weatherService.getLiveWeather(city);
    return res.status(200).json({ data: weather });
  } catch (err) {
    console.error('[Cities] Weather error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/v1/cities/:id/forecast
router.get('/:id/forecast', async (req, res) => {
  try {
    const days = parseInt(req.query.days, 10) || 5;
    const city = await db.getCityById(req.params.id);
    if (!city) {
      return res.status(404).json({ message: 'City not found' });
    }

    const forecast = await weatherService.getCityForecast(city, days);
    return res.status(200).json({
      data: forecast,
      meta: { days: forecast.length },
    });
  } catch (err) {
    console.error('[Cities] Forecast error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/v1/cities/:id/places
router.get('/:id/places', async (req, res) => {
  try {
    const city = await db.getCityById(req.params.id);
    if (!city) {
      return res.status(404).json({ message: 'City not found' });
    }

    const places = await db.getCityPlaces(city.id);
    return res.status(200).json({ data: places });
  } catch (err) {
    console.error('[Cities] Places error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
