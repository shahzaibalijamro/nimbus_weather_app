// routes/favorites.js
const express = require('express');
const router = express.Router();
const db = require('../db');
const weatherService = require('../services/weather_service');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

// GET /api/v1/favorites
router.get('/', async (req, res) => {
  try {
    const favorites = await db.getFavorites(req.user.id);

    // Attach live weather to each favorite's city
    const favoritesWithWeather = await Promise.all(
      favorites.map(async fav => {
        const weather = await weatherService.getQuickWeather(fav.city);
        return {
          id: fav.id,
          note: fav.note || '',
          createdAt: fav.createdAt,
          city: {
            id: fav.city.id,
            name: fav.city.name || '',
            country: fav.city.country || '',
            weather,
          },
        };
      })
    );

    return res.status(200).json({
      data: favoritesWithWeather,
      meta: {
        total: favoritesWithWeather.length,
      },
    });
  } catch (err) {
    console.error('[Favorites] List error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// POST /api/v1/favorites
router.post('/', async (req, res) => {
  try {
    const { cityId, note = '' } = req.body;
    if (!cityId) {
      return res.status(400).json({ message: 'cityId is required' });
    }

    const city = await db.getCityById(cityId);
    if (!city) {
      return res.status(404).json({ message: 'City not found' });
    }

    const isFav = await db.isCityFavorited(req.user.id, cityId);
    if (isFav) {
      return res.status(409).json({ message: 'City is already in favorites' });
    }

    const newFav = await db.addFavorite(req.user.id, cityId, note);
    const weather = await weatherService.getQuickWeather(city);

    return res.status(201).json({
      data: {
        id: newFav.id,
        note: newFav.note,
        createdAt: newFav.createdAt,
        city: {
          id: city.id,
          name: city.name,
          country: city.country,
          weather,
        },
      },
    });
  } catch (err) {
    console.error('[Favorites] Add error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// PATCH /api/v1/favorites/:id
router.patch('/:id', async (req, res) => {
  try {
    const { note = '' } = req.body;
    const favoriteId = req.params.id;

    const updated = await db.updateFavoriteNote(req.user.id, favoriteId, note);
    if (!updated) {
      return res.status(404).json({ message: 'Favorite not found' });
    }

    const city = await db.getCityById(updated.city.id);
    const weather = await weatherService.getQuickWeather(city || updated.city);

    return res.status(200).json({
      data: {
        id: updated.id,
        note: updated.note,
        createdAt: updated.createdAt,
        city: {
          id: updated.city.id,
          name: updated.city.name,
          country: updated.city.country,
          weather,
        },
      },
    });
  } catch (err) {
    console.error('[Favorites] Update error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// DELETE /api/v1/favorites/:id
router.delete('/:id', async (req, res) => {
  try {
    const favoriteId = req.params.id;
    const deleted = await db.deleteFavorite(req.user.id, favoriteId);
    if (!deleted) {
      return res.status(404).json({ message: 'Favorite not found' });
    }

    return res.status(204).send();
  } catch (err) {
    console.error('[Favorites] Delete error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
