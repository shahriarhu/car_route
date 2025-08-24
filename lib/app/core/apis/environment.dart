enum Environment { production, development, local }

class EnvironmentConfig {
  static late Environment environment;

  /// Initialize the environment at app startup
  static void init(Environment env) {
    environment = env;
  }

  /// Returns base URL based on the environment
  static String get baseUrl {
    switch (environment) {
      case Environment.local:
        return 'http://localhost:8080/';
      case Environment.development:
        return 'https://routes.googleapis.com/';
      case Environment.production:
        return 'https://routes.googleapis.com/';
    }
  }
}
