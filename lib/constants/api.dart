class ApiEndpoints {
  static const _baseURL = 'https://nimbus-api-vtoz.onrender.com/api/v1';
  static const login = '$_baseURL/auth/login';
  static const me = '$_baseURL/auth/me';
  static const signUp = '$_baseURL/auth/register';
  static const regions = '$_baseURL/cities/regions';
  static const cities = '$_baseURL/cities';
  static const favorites = '$_baseURL/favorites';
}
