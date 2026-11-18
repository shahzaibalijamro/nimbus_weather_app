// server.js - Nimbus Weather Custom Backend
require('dotenv').config();
const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const citiesRoutes = require('./routes/cities');
const favoritesRoutes = require('./routes/favorites');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Request logger
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Root & Health Checks
app.get('/', (req, res) => {
  res.json({
    name: 'Nimbus Weather API',
    status: 'online',
    version: '1.0.0',
    documentation: '/api/v1/health',
  });
});

app.get('/api/v1/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptimeSeconds: Math.floor(process.uptime()),
  });
});

// Mount V1 API Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/cities', citiesRoutes);
app.use('/api/v1/favorites', favoritesRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ message: `Route not found: ${req.method} ${req.url}` });
});

// Error Handler
app.use((err, req, res, next) => {
  console.error('[Server Error]', err);
  res.status(500).json({ message: 'Internal server error', error: err.message });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`===============================================`);
  console.log(`  Nimbus Weather Backend is running!`);
  console.log(`  Local URL:        http://localhost:${PORT}`);
  console.log(`  Android Emulator: http://10.0.2.2:${PORT}`);
  console.log(`  API Base:         http://localhost:${PORT}/api/v1`);
  console.log(`===============================================`);
});
