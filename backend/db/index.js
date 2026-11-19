// db/index.js
// Universal database adapter: Supabase PostgreSQL (via DATABASE_URL) with persistent local fallback

const fs = require('fs');
const path = require('path');
const bcrypt = require('bcryptjs');

const isProduction =
  process.env.NODE_ENV === 'production' ||
  process.env.VERCEL === '1';

let pgPool = null;
let isPostgresOnline = false;

const databaseUrl = process.env.DATABASE_URL;

// Production must always have a real database connection configured.
if (isProduction && !databaseUrl) {
  throw new Error('[Database] DATABASE_URL is required in production.');
}

if (databaseUrl && databaseUrl.trim().length > 0) {
  const { Pool } = require('pg');

  pgPool = new Pool({
    connectionString: databaseUrl,

    ssl: databaseUrl.includes('localhost')
      ? false
      : { rejectUnauthorized: false },

    // Start small for serverless deployments.
    max: 1,

    idleTimeoutMillis: 10000,
    connectionTimeoutMillis: 10000,
  });

  // Production must select PostgreSQL immediately.
  // Don't wait for the asynchronous connection test.
  isPostgresOnline = isProduction;

  // Handle errors from idle PostgreSQL clients.
  pgPool.on('error', (err) => {
    console.error('[Database] PostgreSQL pool error:', err);
  });

  // Check connectivity for logging purposes.
  pgPool.query('SELECT 1')
    .then(() => {
      isPostgresOnline = true;
      console.log('[Database] Connected to Supabase PostgreSQL successfully!');
    })
    .catch((err) => {
      console.error(
        '[Database] PostgreSQL connection check failed:',
        err.message
      );

      // Local JSON fallback is allowed only during development.
      if (!isProduction) {
        isPostgresOnline = false;
        console.warn('[Database] Using local JSON storage in development.');
      }
    });

} else {
  console.log('[Database] Using local persistent JSON database');
}

// PostgreSQL errors must never silently fall back in production.
function handlePostgresError(err) {
  if (isProduction) {
    console.error('[Database] PostgreSQL query failed:', err.message);
    throw err;
  }

  isPostgresOnline = false;

  console.warn(
    '[Database] PostgreSQL query failed, falling back to local storage:',
    err.message
  );
}

// Local persistent file path
const DATA_DIR = path.join(__dirname, '..', 'data');
const DB_FILE = path.join(DATA_DIR, 'nimbus_db.json');

// Default initial seed dataset (53 Top Global & Pakistani Cities)
const SEED_CITIES = [
  // --- PAKISTAN (12 Cities) ---
  { id: 'karachi', name: 'Karachi', country: 'Pakistan', region: 'Asia', tagline: 'The City of Lights and bustling Arabian Sea metropolis', population: 16000000, lat: 24.8607, lon: 67.0011, timezone: 'Asia/Karachi' },
  { id: 'lahore', name: 'Lahore', country: 'Pakistan', region: 'Asia', tagline: 'The cultural soul of Pakistan, rich in Mughal grandeur', population: 13000000, lat: 31.5497, lon: 74.3436, timezone: 'Asia/Karachi' },
  { id: 'islamabad', name: 'Islamabad', country: 'Pakistan', region: 'Asia', tagline: 'The serene capital nestled at the foothills of the Margallas', population: 1200000, lat: 33.6844, lon: 73.0479, timezone: 'Asia/Karachi' },
  { id: 'rawalpindi', name: 'Rawalpindi', country: 'Pakistan', region: 'Asia', tagline: 'Vibrant garrison city with historic bazaars and colonial charm', population: 2300000, lat: 33.5651, lon: 73.0169, timezone: 'Asia/Karachi' },
  { id: 'peshawar', name: 'Peshawar', country: 'Pakistan', region: 'Asia', tagline: 'Historic gateway of the Khyber Pass and City of Flowers', population: 2300000, lat: 34.0151, lon: 71.5249, timezone: 'Asia/Karachi' },
  { id: 'multan', name: 'Multan', country: 'Pakistan', region: 'Asia', tagline: 'The ancient City of Saints, mystic shrines, and blue pottery', population: 2100000, lat: 30.1575, lon: 71.5249, timezone: 'Asia/Karachi' },
  { id: 'faisalabad', name: 'Faisalabad', country: 'Pakistan', region: 'Asia', tagline: 'Industrial powerhouse and Manchester of Pakistan', population: 3600000, lat: 31.4504, lon: 73.1350, timezone: 'Asia/Karachi' },
  { id: 'quetta', name: 'Quetta', country: 'Pakistan', region: 'Asia', tagline: 'The Fruit Garden of Pakistan surrounded by rugged peaks', population: 1100000, lat: 30.1798, lon: 66.9750, timezone: 'Asia/Karachi' },
  { id: 'sialkot', name: 'Sialkot', country: 'Pakistan', region: 'Asia', tagline: 'World-renowned hub of surgical craft, sports, and aviation', population: 700000, lat: 32.4945, lon: 74.5229, timezone: 'Asia/Karachi' },
  { id: 'gwadar', name: 'Gwadar', country: 'Pakistan', region: 'Asia', tagline: 'The deep-sea crown jewel overlooking the Arabian Sea', population: 140000, lat: 25.1216, lon: 62.3254, timezone: 'Asia/Karachi' },
  { id: 'murree', name: 'Murree', country: 'Pakistan', region: 'Asia', tagline: 'Queen of the Hills with misty pine forests and winter snow', population: 35000, lat: 33.9070, lon: 73.3943, timezone: 'Asia/Karachi' },
  { id: 'gilgit', name: 'Gilgit', country: 'Pakistan', region: 'Asia', tagline: 'Spectacular mountain hub at the meeting of three giants', population: 220000, lat: 35.9208, lon: 74.3144, timezone: 'Asia/Karachi' },

  // --- ASIA ---
  { id: 'tokyo', name: 'Tokyo', country: 'Japan', region: 'Asia', tagline: 'Where ultramodern neon meets ancient shrines', population: 13960000, lat: 35.6762, lon: 139.6503, timezone: 'Asia/Tokyo' },
  { id: 'singapore', name: 'Singapore', country: 'Singapore', region: 'Asia', tagline: 'A dynamic garden city-state of innovation', population: 5917000, lat: 1.3521, lon: 103.8198, timezone: 'Asia/Singapore' },
  { id: 'bangkok', name: 'Bangkok', country: 'Thailand', region: 'Asia', tagline: 'Ornate temples, street flavors, and vibrant canals', population: 10539000, lat: 13.7563, lon: 100.5018, timezone: 'Asia/Bangkok' },
  { id: 'kuala-lumpur', name: 'Kuala Lumpur', country: 'Malaysia', region: 'Asia', tagline: 'Petronas towers, lush rainforests, and multicultural soul', population: 1980000, lat: 3.1390, lon: 101.6869, timezone: 'Asia/Kuala_Lumpur' },
  { id: 'seoul', name: 'Seoul', country: 'South Korea', region: 'Asia', tagline: 'High-tech metropolis steeped in royal palace heritage', population: 9700000, lat: 37.5665, lon: 126.9780, timezone: 'Asia/Seoul' },
  { id: 'beijing', name: 'Beijing', country: 'China', region: 'Asia', tagline: 'Imperial Forbidden City alongside soaring modern architecture', population: 21540000, lat: 39.9042, lon: 116.4074, timezone: 'Asia/Shanghai' },
  { id: 'shanghai', name: 'Shanghai', country: 'China', region: 'Asia', tagline: 'The Bund skyline, financial energy, and Huangpu riverfront', population: 26320000, lat: 31.2304, lon: 121.4737, timezone: 'Asia/Shanghai' },
  { id: 'hong-kong', name: 'Hong Kong', country: 'Hong Kong', region: 'Asia', tagline: 'Towering skyline framed by Victoria Harbour and peaks', population: 7413000, lat: 22.3193, lon: 114.1694, timezone: 'Asia/Hong_Kong' },
  { id: 'jakarta', name: 'Jakarta', country: 'Indonesia', region: 'Asia', tagline: 'Dynamic Southeast Asian hub of islands and maritime culture', population: 10560000, lat: -6.2088, lon: 106.8456, timezone: 'Asia/Jakarta' },
  { id: 'delhi', name: 'Delhi', country: 'India', region: 'Asia', tagline: 'Historic forts, lively spice markets, and political heart', population: 33000000, lat: 28.6139, lon: 77.2090, timezone: 'Asia/Kolkata' },
  { id: 'mumbai', name: 'Mumbai', country: 'India', region: 'Asia', tagline: 'City of Dreams on the Arabian coast with colonial architecture', population: 21000000, lat: 19.0760, lon: 72.8777, timezone: 'Asia/Kolkata' },
  { id: 'dhaka', name: 'Dhaka', country: 'Bangladesh', region: 'Asia', tagline: 'The city of mosques and vibrant rickshaws on the Buriganga', population: 22000000, lat: 23.8103, lon: 90.4125, timezone: 'Asia/Dhaka' },

  // --- MIDDLE EAST ---
  { id: 'dubai', name: 'Dubai', country: 'United Arab Emirates', region: 'Middle East', tagline: 'An oasis of futuristic architecture, luxury, and desert dunes', population: 3500000, lat: 25.2048, lon: 55.2708, timezone: 'Asia/Dubai' },
  { id: 'doha', name: 'Doha', country: 'Qatar', region: 'Middle East', tagline: 'Gleaming Corniche, world-class art, and Arabian pearl heritage', population: 2382000, lat: 25.2854, lon: 51.5310, timezone: 'Asia/Qatar' },
  { id: 'riyadh', name: 'Riyadh', country: 'Saudi Arabia', region: 'Middle East', tagline: 'Kingdom capital combining ancient Najd heritage with modern vision', population: 7676000, lat: 24.7136, lon: 46.6753, timezone: 'Asia/Riyadh' },
  { id: 'abu-dhabi', name: 'Abu Dhabi', country: 'United Arab Emirates', region: 'Middle East', tagline: 'Capital grandeur, Louvre Abu Dhabi, and Sheikh Zayed Mosque', population: 1540000, lat: 24.4539, lon: 54.3773, timezone: 'Asia/Dubai' },

  // --- EUROPE ---
  { id: 'london', name: 'London', country: 'United Kingdom', region: 'Europe', tagline: 'A historic metropolis with timeless charm', population: 8982000, lat: 51.5074, lon: -0.1278, timezone: 'Europe/London' },
  { id: 'paris', name: 'Paris', country: 'France', region: 'Europe', tagline: 'The city of lights, art, and romantic avenues', population: 2161000, lat: 48.8566, lon: 2.3522, timezone: 'Europe/Paris' },
  { id: 'berlin', name: 'Berlin', country: 'Germany', region: 'Europe', tagline: 'A cultural hub of freedom, art, and rich history', population: 3645000, lat: 52.5200, lon: 13.4050, timezone: 'Europe/Berlin' },
  { id: 'rome', name: 'Rome', country: 'Italy', region: 'Europe', tagline: 'The eternal city filled with imperial wonders', population: 2873000, lat: 41.9028, lon: 12.4964, timezone: 'Europe/Rome' },
  { id: 'madrid', name: 'Madrid', country: 'Spain', region: 'Europe', tagline: 'Sunlit plazas, royal palaces, and master art museums', population: 3223000, lat: 40.4168, lon: -3.7038, timezone: 'Europe/Madrid' },
  { id: 'barcelona', name: 'Barcelona', country: 'Spain', region: 'Europe', tagline: 'Gaudí architecture, Mediterranean beaches, and Gothic quarters', population: 1620000, lat: 41.3879, lon: 2.1699, timezone: 'Europe/Madrid' },
  { id: 'amsterdam', name: 'Amsterdam', country: 'Netherlands', region: 'Europe', tagline: 'Iconic canal rings, cycling culture, and golden age art', population: 821000, lat: 52.3676, lon: 4.9041, timezone: 'Europe/Amsterdam' },
  { id: 'istanbul', name: 'Istanbul', country: 'Turkey', region: 'Europe', tagline: 'The legendary bridge between continents', population: 15460000, lat: 41.0082, lon: 28.9784, timezone: 'Europe/Istanbul' },
  { id: 'vienna', name: 'Vienna', country: 'Austria', region: 'Europe', tagline: 'City of classical music, imperial palaces, and coffee houses', population: 1930000, lat: 48.2082, lon: 16.3738, timezone: 'Europe/Vienna' },
  { id: 'zurich', name: 'Zurich', country: 'Switzerland', region: 'Europe', tagline: 'Alpine lakeside elegance and global financial prestige', population: 402000, lat: 47.3769, lon: 8.5417, timezone: 'Europe/Zurich' },

  // --- NORTH AMERICA ---
  { id: 'new-york', name: 'New York', country: 'United States', region: 'North America', tagline: 'The vibrant city that never sleeps', population: 8336000, lat: 40.7128, lon: -74.0060, timezone: 'America/New_York' },
  { id: 'los-angeles', name: 'Los Angeles', country: 'United States', region: 'North America', tagline: 'Hollywood glamour, palm tree boulevards, and Pacific sunsets', population: 3898000, lat: 34.0522, lon: -118.2437, timezone: 'America/Los_Angeles' },
  { id: 'chicago', name: 'Chicago', country: 'United States', region: 'North America', tagline: 'Architectural marvel on Lake Michigan, blues, and deep-dish', population: 2746000, lat: 41.8781, lon: -87.6298, timezone: 'America/Chicago' },
  { id: 'san-francisco', name: 'San Francisco', country: 'United States', region: 'North America', tagline: 'Golden Gate vistas, rolling cable cars, and tech bay breezes', population: 873000, lat: 37.7749, lon: -122.4194, timezone: 'America/Los_Angeles' },
  { id: 'toronto', name: 'Toronto', country: 'Canada', region: 'North America', tagline: 'A multicultural tapestry on the shores of Lake Ontario', population: 2930000, lat: 43.6532, lon: -79.3832, timezone: 'America/Toronto' },
  { id: 'vancouver', name: 'Vancouver', country: 'Canada', region: 'North America', tagline: 'Coastal seaport where snow-capped peaks meet the Pacific', population: 675000, lat: 49.2827, lon: -123.1207, timezone: 'America/Vancouver' },

  // --- SOUTH AMERICA ---
  { id: 'rio-de-janeiro', name: 'Rio de Janeiro', country: 'Brazil', region: 'South America', tagline: 'Marvelous city of carnival rhythms and golden shores', population: 6748000, lat: -22.9068, lon: -43.1729, timezone: 'America/Sao_Paulo' },
  { id: 'buenos-aires', name: 'Buenos Aires', country: 'Argentina', region: 'South America', tagline: 'The Paris of South America, tango passion, and grand avenues', population: 3120000, lat: -34.6037, lon: -58.3816, timezone: 'America/Argentina/Buenos_Aires' },
  { id: 'santiago', name: 'Santiago', country: 'Chile', region: 'South America', tagline: 'Sophisticated valley metropolis framed by the soaring Andes', population: 6250000, lat: -33.4489, lon: -70.6693, timezone: 'America/Santiago' },

  // --- OCEANIA ---
  { id: 'sydney', name: 'Sydney', country: 'Australia', region: 'Oceania', tagline: 'Iconic harbor vistas and sun-drenched beaches', population: 5312000, lat: -33.8688, lon: 151.2093, timezone: 'Australia/Sydney' },
  { id: 'melbourne', name: 'Melbourne', country: 'Australia', region: 'Oceania', tagline: 'Coffee laneways, live music culture, and world-class arts', population: 5078000, lat: -37.8136, lon: 144.9631, timezone: 'Australia/Melbourne' },
  { id: 'auckland', name: 'Auckland', country: 'New Zealand', region: 'Oceania', tagline: 'City of Sails surrounded by volcanic harbors and green bays', population: 1657000, lat: -36.8485, lon: 174.7633, timezone: 'Pacific/Auckland' },

  // --- AFRICA ---
  { id: 'cairo', name: 'Cairo', country: 'Egypt', region: 'Africa', tagline: 'The majestic cradle of ancient civilization', population: 9540000, lat: 30.0444, lon: 31.2357, timezone: 'Africa/Cairo' },
  { id: 'cape-town', name: 'Cape Town', country: 'South Africa', region: 'Africa', tagline: 'Where dramatic mountains meet two ocean currents', population: 4618000, lat: -33.9249, lon: 18.4241, timezone: 'Africa/Johannesburg' },
  { id: 'nairobi', name: 'Nairobi', country: 'Kenya', region: 'Africa', tagline: 'Green city in the sun where modern skyline borders safari wilderness', population: 4397000, lat: -1.2921, lon: 36.8219, timezone: 'Africa/Nairobi' },
];

const SEED_PLACES = [
  // Pakistan Places
  { id: 'khi-1', cityId: 'karachi', name: 'Clifton Beach & Sea View', type: 'beach' },
  { id: 'khi-2', cityId: 'karachi', name: 'Mazar-e-Quaid (Jinnah Mausoleum)', type: 'landmark' },
  { id: 'khi-3', cityId: 'karachi', name: 'Mohatta Palace Museum', type: 'landmark' },
  { id: 'lhr-1', cityId: 'lahore', name: 'Badshahi Mosque', type: 'landmark' },
  { id: 'lhr-2', cityId: 'lahore', name: 'Lahore Fort (Shahi Qila)', type: 'landmark' },
  { id: 'lhr-3', cityId: 'lahore', name: 'Shalimar Gardens', type: 'landmark' },
  { id: 'isb-1', cityId: 'islamabad', name: 'Faisal Mosque', type: 'landmark' },
  { id: 'isb-2', cityId: 'islamabad', name: 'Daman-e-Koh Margalla Hills', type: 'landmark' },
  { id: 'isb-3', cityId: 'islamabad', name: 'Pakistan Monument', type: 'landmark' },
  { id: 'rwp-1', cityId: 'rawalpindi', name: 'Ayub National Park', type: 'landmark' },
  { id: 'rwp-2', cityId: 'rawalpindi', name: 'Raja Bazaar Old Quarter', type: 'landmark' },
  { id: 'pew-1', cityId: 'peshawar', name: 'Bala Hissar Fort', type: 'landmark' },
  { id: 'pew-2', cityId: 'peshawar', name: 'Qissa Khwani Bazaar', type: 'landmark' },
  { id: 'mux-1', cityId: 'multan', name: 'Tomb of Shah Rukn-e-Alam', type: 'landmark' },
  { id: 'mux-2', cityId: 'multan', name: 'Multan Qila Kohna', type: 'landmark' },
  { id: 'fsd-1', cityId: 'faisalabad', name: 'Clock Tower (Ghanta Ghar)', type: 'landmark' },
  { id: 'fsd-2', cityId: 'faisalabad', name: 'D Ground Boulevard', type: 'landmark' },
  { id: 'qta-1', cityId: 'quetta', name: 'Hanna Lake', type: 'beach' },
  { id: 'qta-2', cityId: 'quetta', name: 'Quetta Chiltan Viewpoint', type: 'landmark' },
  { id: 'skt-1', cityId: 'sialkot', name: 'Iqbal Manzil', type: 'landmark' },
  { id: 'skt-2', cityId: 'sialkot', name: 'Sialkot Clock Tower', type: 'landmark' },
  { id: 'gwd-1', cityId: 'gwadar', name: 'Gwadar Hammerhead Point', type: 'landmark' },
  { id: 'gwd-2', cityId: 'gwadar', name: 'Omani Promenade Beach', type: 'beach' },
  { id: 'mrr-1', cityId: 'murree', name: 'Mall Road Murree', type: 'landmark' },
  { id: 'mrr-2', cityId: 'murree', name: 'Patriata Chairlift & Forest', type: 'landmark' },
  { id: 'glt-1', cityId: 'gilgit', name: 'Karakoram Highway Overlook', type: 'landmark' },
  { id: 'glt-2', cityId: 'gilgit', name: 'Naltar Valley Lakes', type: 'landmark' },

  // Global Places
  { id: 'lon-1', cityId: 'london', name: 'Tower Bridge', type: 'landmark' },
  { id: 'lon-2', cityId: 'london', name: 'British Museum', type: 'landmark' },
  { id: 'par-1', cityId: 'paris', name: 'Eiffel Tower', type: 'landmark' },
  { id: 'par-2', cityId: 'paris', name: 'Louvre Museum', type: 'landmark' },
  { id: 'tok-1', cityId: 'tokyo', name: 'Senso-ji Temple', type: 'landmark' },
  { id: 'tok-2', cityId: 'tokyo', name: 'Shibuya Crossing', type: 'landmark' },
  { id: 'nyc-1', cityId: 'new-york', name: 'Central Park', type: 'landmark' },
  { id: 'nyc-2', cityId: 'new-york', name: 'Empire State Building', type: 'landmark' },
  { id: 'dxb-1', cityId: 'dubai', name: 'Burj Khalifa', type: 'landmark' },
  { id: 'dxb-2', cityId: 'dubai', name: 'Jumeirah Beach', type: 'beach' },
  { id: 'syd-1', cityId: 'sydney', name: 'Sydney Opera House', type: 'landmark' },
  { id: 'syd-2', cityId: 'sydney', name: 'Bondi Beach', type: 'beach' },
  { id: 'sin-1', cityId: 'singapore', name: 'Marina Bay Sands', type: 'landmark' },
  { id: 'sin-2', cityId: 'singapore', name: 'Gardens by the Bay', type: 'landmark' },
  { id: 'cai-1', cityId: 'cairo', name: 'Pyramids of Giza', type: 'landmark' },
  { id: 'cai-2', cityId: 'cairo', name: 'Egyptian Museum', type: 'landmark' },
  { id: 'rio-1', cityId: 'rio-de-janeiro', name: 'Christ the Redeemer', type: 'landmark' },
  { id: 'rio-2', cityId: 'rio-de-janeiro', name: 'Copacabana Beach', type: 'beach' },
  { id: 'ber-1', cityId: 'berlin', name: 'Brandenburg Gate', type: 'landmark' },
  { id: 'tor-1', cityId: 'toronto', name: 'CN Tower', type: 'landmark' },
  { id: 'rom-1', cityId: 'rome', name: 'Colosseum', type: 'landmark' },
  { id: 'ist-1', cityId: 'istanbul', name: 'Hagia Sophia', type: 'landmark' },
  { id: 'bkk-1', cityId: 'bangkok', name: 'Grand Palace', type: 'landmark' },
  { id: 'kl-1', cityId: 'kuala-lumpur', name: 'Petronas Twin Towers', type: 'landmark' },
  { id: 'seo-1', cityId: 'seoul', name: 'Gyeongbokgung Palace', type: 'landmark' },
  { id: 'doh-1', cityId: 'doha', name: 'Souq Waqif', type: 'landmark' },
  { id: 'cpt-1', cityId: 'cape-town', name: 'Table Mountain', type: 'landmark' },
  { id: 'cpt-2', cityId: 'cape-town', name: 'Camps Bay Beach', type: 'beach' },
];

let localDb = {
  users: [],
  cities: SEED_CITIES,
  cityPlaces: SEED_PLACES,
  favorites: [],
};

function initLocalDb() {
  if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
  }

  if (fs.existsSync(DB_FILE)) {
    try {
      const data = JSON.parse(fs.readFileSync(DB_FILE, 'utf-8'));
      localDb = {
        users: data.users || [],
        cities: data.cities && data.cities.length ? data.cities : SEED_CITIES,
        cityPlaces: data.cityPlaces && data.cityPlaces.length ? data.cityPlaces : SEED_PLACES,
        favorites: data.favorites || [],
      };
    } catch (e) {
      console.error('[Database] Failed to read existing JSON db, re-initializing', e);
    }
  }

  // Ensure demo user exists
  const demoExists = localDb.users.some(u => u.email === 'demo@nimbus.app');
  if (!demoExists) {
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync('demo1234', salt);
    localDb.users.push({
      id: 1,
      name: 'Demo Explorer',
      email: 'demo@nimbus.app',
      passwordHash: hash,
      createdAt: new Date().toISOString(),
    });
  }

  // Ensure default favorites exist for demo user
  if (!localDb.favorites.some(f => f.userId === 1)) {
    localDb.favorites.push(
      { id: 1, userId: 1, cityId: 'paris', note: 'Weekend getaway & Louvre Museum', createdAt: new Date().toISOString() },
      { id: 2, userId: 1, cityId: 'tokyo', note: 'Spring cherry blossoms & Shibuya', createdAt: new Date().toISOString() },
      { id: 3, userId: 1, cityId: 'new-york', note: 'Broadway shows & Central Park', createdAt: new Date().toISOString() },
      { id: 4, userId: 1, cityId: 'sydney', note: 'Bondi beach & coastal walks', createdAt: new Date().toISOString() }
    );
  }

  saveLocalDb();
}

function saveLocalDb() {
  try {
    fs.writeFileSync(DB_FILE, JSON.stringify(localDb, null, 2), 'utf-8');
  } catch (err) {
    console.error('[Database] Failed to save local DB:', err);
  }
}

if (!isProduction) {
  initLocalDb();
}

// ========================================================
// Database Access Methods
// ========================================================

async function getUserByEmail(email) {
  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('SELECT * FROM public.users WHERE email = $1', [email.toLowerCase()]);
      if (!res.rows.length) return null;
      const r = res.rows[0];
      return {
        id: r.id,
        name: r.name,
        email: r.email,
        passwordHash: r.password_hash,
        createdAt: r.created_at,
      };
    }catch (e) {
  handlePostgresError(e);
}
  }

  const u = localDb.users.find(u => u.email.toLowerCase() === email.toLowerCase());
  return u || null;
}

async function getUserById(id) {
  const numId = Number(id);
  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('SELECT * FROM public.users WHERE id = $1', [numId]);
      if (!res.rows.length) return null;
      const r = res.rows[0];
      return {
        id: r.id,
        name: r.name,
        email: r.email,
        passwordHash: r.password_hash,
        createdAt: r.created_at,
      };
    }catch (e) {
  handlePostgresError(e);
}
  }

  const u = localDb.users.find(u => u.id === numId);
  return u || null;
}

async function createUser({ name, email, password }) {
  const salt = await bcrypt.genSalt(10);
  const passwordHash = await bcrypt.hash(password, salt);

  if (isPostgresOnline) {
    try {
      const res = await pgPool.query(
        'INSERT INTO public.users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING *',
        [name, email.toLowerCase(), passwordHash]
      );
      const r = res.rows[0];
      return {
        id: r.id,
        name: r.name,
        email: r.email,
        createdAt: r.created_at,
      };
    }catch (e) {
  handlePostgresError(e);
}
  }

  const nextId = localDb.users.length ? Math.max(...localDb.users.map(u => u.id)) + 1 : 1;
  const newUser = {
    id: nextId,
    name,
    email: email.toLowerCase(),
    passwordHash,
    createdAt: new Date().toISOString(),
  };
  localDb.users.push(newUser);
  saveLocalDb();

  return {
    id: newUser.id,
    name: newUser.name,
    email: newUser.email,
    createdAt: newUser.createdAt,
  };
}

async function updateUser(id, { name, email, password }) {
  const numId = Number(id);
  let passwordHash = null;
  if (password) {
    const salt = await bcrypt.genSalt(10);
    passwordHash = await bcrypt.hash(password, salt);
  }

  if (isPostgresOnline) {
    try {
      const query = passwordHash
        ? 'UPDATE public.users SET name = $1, email = $2, password_hash = $3 WHERE id = $4 RETURNING *'
        : 'UPDATE public.users SET name = $1, email = $2 WHERE id = $3 RETURNING *';
      const params = passwordHash
        ? [name, email.toLowerCase(), passwordHash, numId]
        : [name, email.toLowerCase(), numId];
      const res = await pgPool.query(query, params);
      const r = res.rows[0];
      return {
        id: r.id,
        name: r.name,
        email: r.email,
        createdAt: r.created_at,
      };
    }catch (e) {
  handlePostgresError(e);
}
  }

  const user = localDb.users.find(u => u.id === numId);
  if (!user) return null;

  if (name) user.name = name;
  if (email) user.email = email.toLowerCase();
  if (passwordHash) user.passwordHash = passwordHash;

  saveLocalDb();

  return {
    id: user.id,
    name: user.name,
    email: user.email,
    createdAt: user.createdAt,
  };
}

async function getRegions() {
  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('SELECT region AS name, COUNT(*)::int AS count FROM public.cities GROUP BY region ORDER BY region');
      return res.rows;
    }catch (e) {
  handlePostgresError(e);
}
  }

  const regionCounts = {};
  for (const c of localDb.cities) {
    regionCounts[c.region] = (regionCounts[c.region] || 0) + 1;
  }
  return Object.keys(regionCounts).sort().map(region => ({
    name: region,
    count: regionCounts[region],
  }));
}

async function getCities({ region, search, page = 1, limit = 8 }) {
  let allCities = [];

  if (isPostgresOnline) {
    try {
      let query = 'SELECT * FROM public.cities WHERE 1=1';
      const params = [];
      if (region && region !== 'All') {
        params.push(region);
        query += ` AND region = $${params.length}`;
      }
      if (search && search.trim()) {
        params.push(`%${search.trim().toLowerCase()}%`);
        query += ` AND (LOWER(name) LIKE $${params.length} OR LOWER(country) LIKE $${params.length})`;
      }
      query += ' ORDER BY country, name';
      const res = await pgPool.query(query, params);
      allCities = res.rows.map(r => ({
        id: r.id,
        name: r.name,
        country: r.country,
        region: r.region,
        tagline: r.tagline,
        population: r.population,
        lat: Number(r.lat),
        lon: Number(r.lon),
        timezone: r.timezone,
      }));
    }catch (e) {
  handlePostgresError(e);
}
  }

 if (!isPostgresOnline) {
  allCities = localDb.cities.filter(c => {
      if (region && region !== 'All' && c.region !== region) return false;
      if (search && search.trim()) {
        const q = search.trim().toLowerCase();
        const matchesName = c.name.toLowerCase().includes(q);
        const matchesCountry = c.country.toLowerCase().includes(q);
        if (!matchesName && !matchesCountry) return false;
      }
      return true;
    });
  }

  const total = allCities.length;
  const totalPages = Math.ceil(total / limit) || 1;
  const startIndex = (page - 1) * limit;
  const pageCities = allCities.slice(startIndex, startIndex + limit);

  return {
    cities: pageCities,
    meta: {
      page: Number(page),
      limit: Number(limit),
      total,
      totalPages,
      hasNext: page < totalPages,
      hasPrev: page > 1,
    },
  };
}

async function getCityById(id) {
  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('SELECT * FROM public.cities WHERE id = $1', [id]);
      if (res.rows.length) {
        const r = res.rows[0];
        return {
          id: r.id,
          name: r.name,
          country: r.country,
          region: r.region,
          tagline: r.tagline,
          population: r.population,
          lat: Number(r.lat),
          lon: Number(r.lon),
          timezone: r.timezone,
        };
      }
    }catch (e) {
  handlePostgresError(e);
}
  }

  const c = localDb.cities.find(c => c.id.toLowerCase() === id.toLowerCase());
  return c || null;
}

async function getCityPlaces(cityId) {
  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('SELECT * FROM public.city_places WHERE city_id = $1', [cityId]);
      return res.rows.map(r => ({ id: r.id, name: r.name, type: r.type }));
    }catch (e) {
  handlePostgresError(e);
}
  }

  return localDb.cityPlaces.filter(p => p.cityId.toLowerCase() === cityId.toLowerCase()).map(p => ({
    id: p.id,
    name: p.name,
    type: p.type,
  }));
}

async function getFavorites(userId) {
  const numUserId = Number(userId);

  if (isPostgresOnline) {
    try {
      const res = await pgPool.query(
        `SELECT f.id, f.note, f.created_at, c.id AS city_id, c.name AS city_name, c.country AS city_country, c.lat, c.lon
         FROM public.favorites f
         JOIN public.cities c ON f.city_id = c.id
         WHERE f.user_id = $1
         ORDER BY f.created_at DESC`,
        [numUserId]
      );
      return res.rows.map(r => ({
        id: r.id,
        note: r.note || '',
        createdAt: r.created_at,
        city: {
          id: r.city_id,
          name: r.city_name,
          country: r.city_country || r.country || '',
          lat: Number(r.lat),
          lon: Number(r.lon),
        },
      }));
    }catch (e) {
  handlePostgresError(e);
}
  }

  const userFavs = localDb.favorites.filter(f => f.userId === numUserId);
  return userFavs.map(f => {
    const city = localDb.cities.find(c => c.id === f.cityId) || { id: f.cityId, name: f.cityId, country: '', lat: 0, lon: 0 };
    return {
      id: f.id,
      note: f.note || '',
      createdAt: f.createdAt,
      city: {
        id: city.id,
        name: city.name,
        country: city.country,
        lat: city.lat,
        lon: city.lon,
      },
    };
  });
}

async function isCityFavorited(userId, cityId) {
  const numUserId = Number(userId);
  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('SELECT id FROM public.favorites WHERE user_id = $1 AND city_id = $2', [numUserId, cityId]);
      return res.rows.length > 0;
    }catch (e) {
  handlePostgresError(e);
}
  }
  return localDb.favorites.some(f => f.userId === numUserId && f.cityId.toLowerCase() === cityId.toLowerCase());
}

async function addFavorite(userId, cityId, note = '') {
  const numUserId = Number(userId);

  if (isPostgresOnline) {
    try {
      const res = await pgPool.query(
        'INSERT INTO public.favorites (user_id, city_id, note) VALUES ($1, $2, $3) RETURNING *',
        [numUserId, cityId, note]
      );
      const r = res.rows[0];
      const city = await getCityById(cityId);
      return {
        id: r.id,
        note: r.note || '',
        createdAt: r.created_at,
        city: city || { id: cityId, name: cityId, country: '', lat: 0, lon: 0 },
      };
    }catch (e) {
  handlePostgresError(e);
}
  }

  const nextId = localDb.favorites.length ? Math.max(...localDb.favorites.map(f => f.id)) + 1 : 1;
  const newFav = {
    id: nextId,
    userId: numUserId,
    cityId,
    note,
    createdAt: new Date().toISOString(),
  };
  localDb.favorites.push(newFav);
  saveLocalDb();

  const city = localDb.cities.find(c => c.id.toLowerCase() === cityId.toLowerCase()) || { id: cityId, name: cityId, country: '', lat: 0, lon: 0 };
  return {
    id: newFav.id,
    note: newFav.note,
    createdAt: newFav.createdAt,
    city,
  };
}

async function updateFavoriteNote(userId, favoriteId, note) {
  const numUserId = Number(userId);
  const numFavId = Number(favoriteId);

  if (isPostgresOnline) {
    try {
      const res = await pgPool.query(
        'UPDATE public.favorites SET note = $1 WHERE id = $2 AND user_id = $3 RETURNING *',
        [note, numFavId, numUserId]
      );
      if (res.rows.length) {
        const r = res.rows[0];
        const city = await getCityById(r.city_id);
        return {
          id: r.id,
          note: r.note || '',
          createdAt: r.created_at,
          city: city || { id: r.city_id, name: r.city_id, country: '', lat: 0, lon: 0 },
        };
      }
    }catch (e) {
  handlePostgresError(e);
}
  }

  const fav = localDb.favorites.find(f => f.id === numFavId && f.userId === numUserId);
  if (!fav) return null;
  fav.note = note;
  saveLocalDb();

  const city = localDb.cities.find(c => c.id === fav.cityId) || { id: fav.cityId, name: fav.cityId, country: '', lat: 0, lon: 0 };
  return {
    id: fav.id,
    note: fav.note,
    createdAt: fav.createdAt,
    city,
  };
}

async function deleteFavorite(userId, favoriteId) {
  const numUserId = Number(userId);
  const numFavId = Number(favoriteId);

  if (isPostgresOnline) {
    try {
      const res = await pgPool.query('DELETE FROM public.favorites WHERE id = $1 AND user_id = $2', [numFavId, numUserId]);
      return res.rowCount > 0;
    }catch (e) {
  handlePostgresError(e);
}
  }

  const idx = localDb.favorites.findIndex(f => f.id === numFavId && f.userId === numUserId);
  if (idx === -1) return false;
  localDb.favorites.splice(idx, 1);
  saveLocalDb();
  return true;
}

module.exports = {
  getUserByEmail,
  getUserById,
  createUser,
  updateUser,
  getRegions,
  getCities,
  getCityById,
  getCityPlaces,
  getFavorites,
  isCityFavorited,
  addFavorite,
  updateFavoriteNote,
  deleteFavorite,
};
