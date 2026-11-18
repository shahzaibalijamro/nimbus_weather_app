class ApiEndpoints {
  // Configurable base URL:
  // Automatically detects Android emulator (10.0.2.2) vs Windows/Web/Desktop (localhost).
  // Replace with your deployed URL (e.g. Render/Railway) whenever ready!
  static String get _baseURL {
    return 'http://192.168.1.41:3000/api/v1';
  }

  static String get login => '$_baseURL/auth/login';
  static String get me => '$_baseURL/auth/me';
  static String get updateProfile => '$_baseURL/auth/me';
  static String get signUp => '$_baseURL/auth/register';
  static String get regions => '$_baseURL/cities/regions';
  static String get cities => '$_baseURL/cities';
  static String get favorites => '$_baseURL/favorites';
}
