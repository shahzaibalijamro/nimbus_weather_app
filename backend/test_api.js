// test_api.js - Automated verification suite for Nimbus API
const BASE_URL = process.env.TEST_URL || 'http://localhost:3000/api/v1';

async function runTests() {
  console.log(`Starting automated API test against ${BASE_URL}...\n`);
  let passed = 0;
  let failed = 0;

  async function test(name, fn) {
    try {
      await fn();
      console.log(`  [PASS] ${name}`);
      passed++;
    } catch (err) {
      console.error(`  [FAIL] ${name}:`, err.message);
      failed++;
    }
  }

  let demoToken = '';
  let newUserId = null;
  let newUserToken = '';
  let favId = null;

  // 1. Health Check
  await test('GET /health', async () => {
    const res = await fetch(`${BASE_URL}/health`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.status !== 'healthy') throw new Error('Expected healthy status');
  });

  // 2. Demo User Login
  await test('POST /auth/login (Demo Account)', async () => {
    const res = await fetch(`${BASE_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'demo@nimbus.app', password: 'demo1234' }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (!data.token) throw new Error('No token returned');
    if (data.expiresInSeconds !== 2592000) throw new Error('Expected 30-day expiration (2592000s)');
    demoToken = data.token;
  });

  // 3. GET /auth/me with Demo User
  await test('GET /auth/me (Bearer Token)', async () => {
    const res = await fetch(`${BASE_URL}/auth/me`, {
      headers: { Authorization: `Bearer ${demoToken}` },
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.user.email !== 'demo@nimbus.app') throw new Error('Unexpected user email');
  });

  // 4. Register New User
  const randomEmail = `testuser_${Date.now()}@nimbus.app`;
  await test('POST /auth/register', async () => {
    const res = await fetch(`${BASE_URL}/auth/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Alex Nimbus', email: randomEmail, password: 'password123' }),
    });
    if (res.status !== 201) throw new Error(`Expected 201, got ${res.status}`);
  });

  // 5. Login with New User
  await test('POST /auth/login (New User)', async () => {
    const res = await fetch(`${BASE_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: randomEmail, password: 'password123' }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    newUserToken = data.token;
    newUserId = data.user.id;
  });

  // 6. PATCH /auth/me (Profile Edit)
  await test('PATCH /auth/me (Update Name & Email)', async () => {
    const res = await fetch(`${BASE_URL}/auth/me`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${newUserToken}`,
      },
      body: JSON.stringify({ name: 'Alex Updated', email: `updated_${randomEmail}` }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.user.name !== 'Alex Updated') throw new Error('Name not updated');
  });

  // 7. GET /cities/regions
  await test('GET /cities/regions', async () => {
    const res = await fetch(`${BASE_URL}/cities/regions`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (!Array.isArray(data.data) || data.data.length === 0) throw new Error('Empty regions');
  });

  // 8. GET /cities (List with live weather)
  await test('GET /cities?limit=4', async () => {
    const res = await fetch(`${BASE_URL}/cities?limit=4`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.data.length !== 4) throw new Error(`Expected 4 cities, got ${data.data.length}`);
    const first = data.data[0];
    if (typeof first.weather.temperatureC !== 'number') throw new Error('Missing temperatureC');
    if (!first.weather.condition || !first.weather.condition.icon) throw new Error('Missing condition icon');
  });

  // 9. GET /cities/london
  await test('GET /cities/london', async () => {
    const res = await fetch(`${BASE_URL}/cities/london`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.data.name !== 'London') throw new Error('Expected London');
    if (!data.data.coordinates || !data.data.coordinates.lat) throw new Error('Missing coordinates');
  });

  // 10. GET /cities/london/weather (Live weather)
  await test('GET /cities/london/weather', async () => {
    const res = await fetch(`${BASE_URL}/cities/london/weather`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (typeof data.data.temperatureC !== 'number') throw new Error('Invalid temperature');
    if (typeof data.data.humidity !== 'number') throw new Error('Invalid humidity');
  });

  // 11. GET /cities/london/forecast
  await test('GET /cities/london/forecast?days=5', async () => {
    const res = await fetch(`${BASE_URL}/cities/london/forecast?days=5`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.data.length !== 5) throw new Error(`Expected 5 forecast days, got ${data.data.length}`);
    if (typeof data.data[0].highC !== 'number') throw new Error('Invalid highC in forecast');
  });

  // 12. GET /cities/london/places
  await test('GET /cities/london/places', async () => {
    const res = await fetch(`${BASE_URL}/cities/london/places`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (!Array.isArray(data.data) || data.data.length === 0) throw new Error('Empty places');
  });

  // 13. POST /favorites (Add favorite)
  await test('POST /favorites', async () => {
    const res = await fetch(`${BASE_URL}/favorites`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${demoToken}`,
      },
      body: JSON.stringify({ cityId: 'paris', note: 'Weekend trip' }),
    });
    if (res.status !== 201) throw new Error(`Expected 201, got ${res.status}`);
    const data = await res.json();
    favId = data.data.id;
  });

  // 14. GET /favorites
  await test('GET /favorites', async () => {
    const res = await fetch(`${BASE_URL}/favorites`, {
      headers: { Authorization: `Bearer ${demoToken}` },
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (!data.data.some(f => f.city.id === 'paris')) throw new Error('Paris not found in favorites');
  });

  // 15. PATCH /favorites/:id (Update note)
  await test('PATCH /favorites/:id', async () => {
    const res = await fetch(`${BASE_URL}/favorites/${favId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${demoToken}`,
      },
      body: JSON.stringify({ note: 'Updated holiday notes' }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    if (data.data.note !== 'Updated holiday notes') throw new Error('Note was not updated');
  });

  // 16. DELETE /favorites/:id
  await test('DELETE /favorites/:id', async () => {
    const res = await fetch(`${BASE_URL}/favorites/${favId}`, {
      method: 'DELETE',
      headers: { Authorization: `Bearer ${demoToken}` },
    });
    if (res.status !== 204) throw new Error(`Expected 204, got ${res.status}`);
  });

  console.log(`\n========================================`);
  console.log(`Tests Completed: ${passed} passed, ${failed} failed`);
  console.log(`========================================\n`);

  if (failed > 0) process.exit(1);
}

runTests().catch(err => {
  console.error('Test suite failed:', err);
  process.exit(1);
});
