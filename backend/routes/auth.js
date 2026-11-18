// routes/auth.js
const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../db');
const { authenticateToken, JWT_SECRET } = require('../middleware/auth');

const TOKEN_EXPIRY_SECONDS = 30 * 24 * 60 * 60; // 30 Days (2,592,000s)

// POST /api/v1/auth/register
router.post('/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;
    if (!name || !name.trim()) {
      return res.status(400).json({ message: 'Name is required' });
    }
    if (!email || !email.trim()) {
      return res.status(400).json({ message: 'Email is required' });
    }
    if (!password || password.length < 6) {
      return res.status(400).json({ message: 'Password must be at least 6 characters' });
    }

    const existing = await db.getUserByEmail(email);
    if (existing) {
      return res.status(409).json({ message: 'User already exists with this email' });
    }

    const user = await db.createUser({ name: name.trim(), email: email.trim(), password });
    return res.status(201).json({
      message: 'User created successfully',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt,
      },
    });
  } catch (err) {
    console.error('[Auth] Register error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// POST /api/v1/auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    const user = await db.getUserByEmail(email);
    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      JWT_SECRET,
      { expiresIn: `${TOKEN_EXPIRY_SECONDS}s` }
    );

    return res.status(200).json({
      token,
      expiresInSeconds: TOKEN_EXPIRY_SECONDS,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt,
      },
    });
  } catch (err) {
    console.error('[Auth] Login error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/v1/auth/me
router.get('/me', authenticateToken, async (req, res) => {
  try {
    return res.status(200).json({
      expiresInSeconds: TOKEN_EXPIRY_SECONDS,
      user: {
        id: req.user.id,
        name: req.user.name,
        email: req.user.email,
        createdAt: req.user.createdAt,
      },
    });
  } catch (err) {
    console.error('[Auth] Me error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// PATCH /api/v1/auth/me (Profile Edit)
router.patch('/me', authenticateToken, async (req, res) => {
  try {
    if (req.user.email.toLowerCase() === 'demo@nimbus.app') {
      return res.status(403).json({ message: 'Editing is disabled on the shared demo account' });
    }

    const { name, email, currentPassword, newPassword } = req.body;
    const userId = req.user.id;

    if (email && email.trim().toLowerCase() !== req.user.email.toLowerCase()) {
      const existing = await db.getUserByEmail(email);
      if (existing && existing.id !== userId) {
        return res.status(409).json({ message: 'Email is already taken by another account' });
      }
    }

    let passwordToUpdate = null;
    if (newPassword && newPassword.trim()) {
      if (!currentPassword) {
        return res.status(400).json({ message: 'Current password is required to set a new password' });
      }
      const isCurrentValid = await bcrypt.compare(currentPassword, req.user.passwordHash);
      if (!isCurrentValid) {
        return res.status(400).json({ message: 'Current password is incorrect' });
      }
      if (newPassword.length < 6) {
        return res.status(400).json({ message: 'New password must be at least 6 characters' });
      }
      passwordToUpdate = newPassword;
    }

    const updated = await db.updateUser(userId, {
      name: name ? name.trim() : req.user.name,
      email: email ? email.trim() : req.user.email,
      password: passwordToUpdate,
    });

    return res.status(200).json({
      message: 'Profile updated successfully',
      user: {
        id: updated.id,
        name: updated.name,
        email: updated.email,
        createdAt: updated.createdAt,
      },
    });
  } catch (err) {
    console.error('[Auth] Update profile error:', err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
