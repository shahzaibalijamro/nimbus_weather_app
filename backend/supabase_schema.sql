-- ========================================================
-- Nimbus Weather App - Supabase PostgreSQL Schema & Seeds
-- ========================================================

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table
CREATE TABLE IF NOT EXISTS public.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Cities Table
CREATE TABLE IF NOT EXISTS public.cities (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    region VARCHAR(100) NOT NULL,
    tagline TEXT NOT NULL,
    population INT NOT NULL,
    lat NUMERIC(8, 4) NOT NULL,
    lon NUMERIC(8, 4) NOT NULL,
    timezone VARCHAR(100) NOT NULL
);

-- 3. City Places Table (Landmarks & Attractions)
CREATE TABLE IF NOT EXISTS public.city_places (
    id VARCHAR(100) PRIMARY KEY,
    city_id VARCHAR(100) REFERENCES public.cities(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL -- 'beach', 'landmark', etc.
);

-- 4. Favorites Table
CREATE TABLE IF NOT EXISTS public.favorites (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES public.users(id) ON DELETE CASCADE,
    city_id VARCHAR(100) REFERENCES public.cities(id) ON DELETE CASCADE,
    note TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, city_id)
);

-- Indexes for optimal lookup speeds
CREATE INDEX IF NOT EXISTS idx_favorites_user ON public.favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_cities_region ON public.cities(region);
CREATE INDEX IF NOT EXISTS idx_city_places_city ON public.city_places(city_id);

-- ========================================================
-- Seed Data: 53 Top Global & Pakistani Cities
-- ========================================================

INSERT INTO public.cities (id, name, country, region, tagline, population, lat, lon, timezone) VALUES
-- --- PAKISTAN (12 Cities) ---
('karachi', 'Karachi', 'Pakistan', 'Asia', 'The City of Lights and bustling Arabian Sea metropolis', 16000000, 24.8607, 67.0011, 'Asia/Karachi'),
('lahore', 'Lahore', 'Pakistan', 'Asia', 'The cultural soul of Pakistan, rich in Mughal grandeur', 13000000, 31.5497, 74.3436, 'Asia/Karachi'),
('islamabad', 'Islamabad', 'Pakistan', 'Asia', 'The serene capital nestled at the foothills of the Margallas', 1200000, 33.6844, 73.0479, 'Asia/Karachi'),
('rawalpindi', 'Rawalpindi', 'Pakistan', 'Asia', 'Vibrant garrison city with historic bazaars and colonial charm', 2300000, 33.5651, 73.0169, 'Asia/Karachi'),
('peshawar', 'Peshawar', 'Pakistan', 'Asia', 'Historic gateway of the Khyber Pass and City of Flowers', 2300000, 34.0151, 71.5249, 'Asia/Karachi'),
('multan', 'Multan', 'Pakistan', 'Asia', 'The ancient City of Saints, mystic shrines, and blue pottery', 2100000, 30.1575, 71.5249, 'Asia/Karachi'),
('faisalabad', 'Faisalabad', 'Pakistan', 'Asia', 'Industrial powerhouse and Manchester of Pakistan', 3600000, 31.4504, 73.1350, 'Asia/Karachi'),
('quetta', 'Quetta', 'Pakistan', 'Asia', 'The Fruit Garden of Pakistan surrounded by rugged peaks', 1100000, 30.1798, 66.9750, 'Asia/Karachi'),
('sialkot', 'Sialkot', 'Pakistan', 'Asia', 'World-renowned hub of surgical craft, sports, and aviation', 700000, 32.4945, 74.5229, 'Asia/Karachi'),
('gwadar', 'Gwadar', 'Pakistan', 'Asia', 'The deep-sea crown jewel overlooking the Arabian Sea', 140000, 25.1216, 62.3254, 'Asia/Karachi'),
('murree', 'Murree', 'Pakistan', 'Asia', 'Queen of the Hills with misty pine forests and winter snow', 35000, 33.9070, 73.3943, 'Asia/Karachi'),
('gilgit', 'Gilgit', 'Pakistan', 'Asia', 'Spectacular mountain hub at the meeting of three giants', 220000, 35.9208, 74.3144, 'Asia/Karachi'),

-- --- ASIA ---
('tokyo', 'Tokyo', 'Japan', 'Asia', 'Where ultramodern neon meets ancient shrines', 13960000, 35.6762, 139.6503, 'Asia/Tokyo'),
('singapore', 'Singapore', 'Singapore', 'Asia', 'A dynamic garden city-state of innovation', 5917000, 1.3521, 103.8198, 'Asia/Singapore'),
('bangkok', 'Bangkok', 'Thailand', 'Asia', 'Ornate temples, street flavors, and vibrant canals', 10539000, 13.7563, 100.5018, 'Asia/Bangkok'),
('kuala-lumpur', 'Kuala Lumpur', 'Malaysia', 'Asia', 'Petronas towers, lush rainforests, and multicultural soul', 1980000, 3.1390, 101.6869, 'Asia/Kuala_Lumpur'),
('seoul', 'Seoul', 'South Korea', 'Asia', 'High-tech metropolis steeped in royal palace heritage', 9700000, 37.5665, 126.9780, 'Asia/Seoul'),
('beijing', 'Beijing', 'China', 'Asia', 'Imperial Forbidden City alongside soaring modern architecture', 21540000, 39.9042, 116.4074, 'Asia/Shanghai'),
('shanghai', 'Shanghai', 'China', 'Asia', 'The Bund skyline, financial energy, and Huangpu riverfront', 26320000, 31.2304, 121.4737, 'Asia/Shanghai'),
('hong-kong', 'Hong Kong', 'Hong Kong', 'Asia', 'Towering skyline framed by Victoria Harbour and peaks', 7413000, 22.3193, 114.1694, 'Asia/Hong_Kong'),
('jakarta', 'Jakarta', 'Indonesia', 'Asia', 'Dynamic Southeast Asian hub of islands and maritime culture', 10560000, -6.2088, 106.8456, 'Asia/Jakarta'),
('delhi', 'Delhi', 'India', 'Asia', 'Historic forts, lively spice markets, and political heart', 33000000, 28.6139, 77.2090, 'Asia/Kolkata'),
('mumbai', 'Mumbai', 'India', 'Asia', 'City of Dreams on the Arabian coast with colonial architecture', 21000000, 19.0760, 72.8777, 'Asia/Kolkata'),
('dhaka', 'Dhaka', 'Bangladesh', 'Asia', 'The city of mosques and vibrant rickshaws on the Buriganga', 22000000, 23.8103, 90.4125, 'Asia/Dhaka'),

-- --- MIDDLE EAST ---
('dubai', 'Dubai', 'United Arab Emirates', 'Middle East', 'An oasis of futuristic architecture, luxury, and desert dunes', 3500000, 25.2048, 55.2708, 'Asia/Dubai'),
('doha', 'Doha', 'Qatar', 'Middle East', 'Gleaming Corniche, world-class art, and Arabian pearl heritage', 2382000, 25.2854, 51.5310, 'Asia/Qatar'),
('riyadh', 'Riyadh', 'Saudi Arabia', 'Middle East', 'Kingdom capital combining ancient Najd heritage with modern vision', 7676000, 24.7136, 46.6753, 'Asia/Riyadh'),
('abu-dhabi', 'Abu Dhabi', 'United Arab Emirates', 'Middle East', 'Capital grandeur, Louvre Abu Dhabi, and Sheikh Zayed Mosque', 1540000, 24.4539, 54.3773, 'Asia/Dubai'),

-- --- EUROPE ---
('london', 'London', 'United Kingdom', 'Europe', 'A historic metropolis with timeless charm', 8982000, 51.5074, -0.1278, 'Europe/London'),
('paris', 'Paris', 'France', 'Europe', 'The city of lights, art, and romantic avenues', 2161000, 48.8566, 2.3522, 'Europe/Paris'),
('berlin', 'Berlin', 'Germany', 'Europe', 'A cultural hub of freedom, art, and rich history', 3645000, 52.5200, 13.4050, 'Europe/Berlin'),
('rome', 'Rome', 'Italy', 'Europe', 'The eternal city filled with imperial wonders', 2873000, 41.9028, 12.4964, 'Europe/Rome'),
('madrid', 'Madrid', 'Spain', 'Europe', 'Sunlit plazas, royal palaces, and master art museums', 3223000, 40.4168, -3.7038, 'Europe/Madrid'),
('barcelona', 'Barcelona', 'Spain', 'Europe', 'Gaudí architecture, Mediterranean beaches, and Gothic quarters', 1620000, 41.3879, 2.1699, 'Europe/Madrid'),
('amsterdam', 'Amsterdam', 'Netherlands', 'Europe', 'Iconic canal rings, cycling culture, and golden age art', 821000, 52.3676, 4.9041, 'Europe/Amsterdam'),
('istanbul', 'Istanbul', 'Turkey', 'Europe', 'The legendary bridge between continents', 15460000, 41.0082, 28.9784, 'Europe/Istanbul'),
('vienna', 'Vienna', 'Austria', 'Europe', 'City of classical music, imperial palaces, and coffee houses', 1930000, 48.2082, 16.3738, 'Europe/Vienna'),
('zurich', 'Zurich', 'Switzerland', 'Europe', 'Alpine lakeside elegance and global financial prestige', 402000, 47.3769, 8.5417, 'Europe/Zurich'),

-- --- NORTH AMERICA ---
('new-york', 'New York', 'United States', 'North America', 'The vibrant city that never sleeps', 8336000, 40.7128, -74.0060, 'America/New_York'),
('los-angeles', 'Los Angeles', 'United States', 'North America', 'Hollywood glamour, palm tree boulevards, and Pacific sunsets', 3898000, 34.0522, -118.2437, 'America/Los_Angeles'),
('chicago', 'Chicago', 'United States', 'North America', 'Architectural marvel on Lake Michigan, blues, and deep-dish', 2746000, 41.8781, -87.6298, 'America/Chicago'),
('san-francisco', 'San Francisco', 'United States', 'North America', 'Golden Gate vistas, rolling cable cars, and tech bay breezes', 873000, 37.7749, -122.4194, 'America/Los_Angeles'),
('toronto', 'Toronto', 'Canada', 'North America', 'A multicultural tapestry on the shores of Lake Ontario', 2930000, 43.6532, -79.3832, 'America/Toronto'),
('vancouver', 'Vancouver', 'Canada', 'North America', 'Coastal seaport where snow-capped peaks meet the Pacific', 675000, 49.2827, -123.1207, 'America/Vancouver'),

-- --- SOUTH AMERICA ---
('rio-de-janeiro', 'Rio de Janeiro', 'Brazil', 'South America', 'Marvelous city of carnival rhythms and golden shores', 6748000, -22.9068, -43.1729, 'America/Sao_Paulo'),
('buenos-aires', 'Buenos Aires', 'Argentina', 'South America', 'The Paris of South America, tango passion, and grand avenues', 3120000, -34.6037, -58.3816, 'America/Argentina/Buenos_Aires'),
('santiago', 'Santiago', 'Chile', 'South America', 'Sophisticated valley metropolis framed by the soaring Andes', 6250000, -33.4489, -70.6693, 'America/Santiago'),

-- --- OCEANIA ---
('sydney', 'Sydney', 'Australia', 'Oceania', 'Iconic harbor vistas and sun-drenched beaches', 5312000, -33.8688, 151.2093, 'Australia/Sydney'),
('melbourne', 'Melbourne', 'Australia', 'Oceania', 'Coffee laneways, live music culture, and world-class arts', 5078000, -37.8136, 144.9631, 'Australia/Melbourne'),
('auckland', 'Auckland', 'New Zealand', 'Oceania', 'City of Sails surrounded by volcanic harbors and green bays', 1657000, -36.8485, 174.7633, 'Pacific/Auckland'),

-- --- AFRICA ---
('cairo', 'Cairo', 'Egypt', 'Africa', 'The majestic cradle of ancient civilization', 9540000, 30.0444, 31.2357, 'Africa/Cairo'),
('cape-town', 'Cape Town', 'South Africa', 'Africa', 'Where dramatic mountains meet two ocean currents', 4618000, -33.9249, 18.4241, 'Africa/Johannesburg'),
('nairobi', 'Nairobi', 'Kenya', 'Africa', 'Green city in the sun where modern skyline borders safari wilderness', 4397000, -1.2921, 36.8219, 'Africa/Nairobi')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  country = EXCLUDED.country,
  region = EXCLUDED.region,
  tagline = EXCLUDED.tagline,
  population = EXCLUDED.population,
  lat = EXCLUDED.lat,
  lon = EXCLUDED.lon,
  timezone = EXCLUDED.timezone;

-- Seed Places / Landmarks
INSERT INTO public.city_places (id, city_id, name, type) VALUES
-- Pakistan Places
('khi-1', 'karachi', 'Clifton Beach & Sea View', 'beach'),
('khi-2', 'karachi', 'Mazar-e-Quaid (Jinnah Mausoleum)', 'landmark'),
('khi-3', 'karachi', 'Mohatta Palace Museum', 'landmark'),
('lhr-1', 'lahore', 'Badshahi Mosque', 'landmark'),
('lhr-2', 'lahore', 'Lahore Fort (Shahi Qila)', 'landmark'),
('lhr-3', 'lahore', 'Shalimar Gardens', 'landmark'),
('isb-1', 'islamabad', 'Faisal Mosque', 'landmark'),
('isb-2', 'islamabad', 'Daman-e-Koh Margalla Hills', 'landmark'),
('isb-3', 'islamabad', 'Pakistan Monument', 'landmark'),
('rwp-1', 'rawalpindi', 'Ayub National Park', 'landmark'),
('rwp-2', 'rawalpindi', 'Raja Bazaar Old Quarter', 'landmark'),
('pew-1', 'peshawar', 'Bala Hissar Fort', 'landmark'),
('pew-2', 'peshawar', 'Qissa Khwani Bazaar', 'landmark'),
('mux-1', 'multan', 'Tomb of Shah Rukn-e-Alam', 'landmark'),
('mux-2', 'multan', 'Multan Qila Kohna', 'landmark'),
('fsd-1', 'faisalabad', 'Clock Tower (Ghanta Ghar)', 'landmark'),
('fsd-2', 'faisalabad', 'D Ground Boulevard', 'landmark'),
('qta-1', 'quetta', 'Hanna Lake', 'beach'),
('qta-2', 'quetta', 'Quetta Chiltan Viewpoint', 'landmark'),
('skt-1', 'sialkot', 'Iqbal Manzil', 'landmark'),
('skt-2', 'sialkot', 'Sialkot Clock Tower', 'landmark'),
('gwd-1', 'gwadar', 'Gwadar Hammerhead Point', 'landmark'),
('gwd-2', 'gwadar', 'Omani Promenade Beach', 'beach'),
('mrr-1', 'murree', 'Mall Road Murree', 'landmark'),
('mrr-2', 'murree', 'Patriata Chairlift & Forest', 'landmark'),
('glt-1', 'gilgit', 'Karakoram Highway Overlook', 'landmark'),
('glt-2', 'gilgit', 'Naltar Valley Lakes', 'landmark'),

-- Global Places
('lon-1', 'london', 'Tower Bridge', 'landmark'),
('lon-2', 'london', 'British Museum', 'landmark'),
('par-1', 'paris', 'Eiffel Tower', 'landmark'),
('par-2', 'paris', 'Louvre Museum', 'landmark'),
('tok-1', 'tokyo', 'Senso-ji Temple', 'landmark'),
('tok-2', 'tokyo', 'Shibuya Crossing', 'landmark'),
('nyc-1', 'new-york', 'Central Park', 'landmark'),
('nyc-2', 'new-york', 'Empire State Building', 'landmark'),
('dxb-1', 'dubai', 'Burj Khalifa', 'landmark'),
('dxb-2', 'dubai', 'Jumeirah Beach', 'beach'),
('syd-1', 'sydney', 'Sydney Opera House', 'landmark'),
('syd-2', 'sydney', 'Bondi Beach', 'beach'),
('sin-1', 'singapore', 'Marina Bay Sands', 'landmark'),
('sin-2', 'singapore', 'Gardens by the Bay', 'landmark'),
('cai-1', 'cairo', 'Pyramids of Giza', 'landmark'),
('cai-2', 'cairo', 'Egyptian Museum', 'landmark'),
('rio-1', 'rio-de-janeiro', 'Christ the Redeemer', 'landmark'),
('rio-2', 'rio-de-janeiro', 'Copacabana Beach', 'beach'),
('ber-1', 'berlin', 'Brandenburg Gate', 'landmark'),
('tor-1', 'toronto', 'CN Tower', 'landmark'),
('rom-1', 'rome', 'Colosseum', 'landmark'),
('ist-1', 'istanbul', 'Hagia Sophia', 'landmark'),
('bkk-1', 'bangkok', 'Grand Palace', 'landmark'),
('kl-1', 'kuala-lumpur', 'Petronas Twin Towers', 'landmark'),
('seo-1', 'seoul', 'Gyeongbokgung Palace', 'landmark'),
('doh-1', 'doha', 'Souq Waqif', 'landmark'),
('cpt-1', 'cape-town', 'Table Mountain', 'landmark'),
('cpt-2', 'cape-town', 'Camps Bay Beach', 'beach')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  type = EXCLUDED.type;

-- Seed Demo User: demo@nimbus.app / password: demo1234
INSERT INTO public.users (name, email, password_hash) VALUES
('Demo Explorer', 'demo@nimbus.app', '$2a$10$wKx60aJj.e8g3u70j8R1A.XvB7aQeM1k6sC4kP0h8vM3aB6d7f9yK')
ON CONFLICT (email) DO UPDATE SET password_hash = EXCLUDED.password_hash;

-- Seed Default Favorites for Demo User
INSERT INTO public.favorites (user_id, city_id, note)
SELECT u.id, f.city_id, f.note
FROM public.users u
CROSS JOIN (
    VALUES 
        ('paris', 'Weekend getaway & Louvre Museum'),
        ('tokyo', 'Spring cherry blossoms & Shibuya'),
        ('new-york', 'Broadway shows & Central Park'),
        ('sydney', 'Bondi beach & coastal walks')
) AS f(city_id, note)
WHERE u.email = 'demo@nimbus.app'
ON CONFLICT (user_id, city_id) DO NOTHING;
