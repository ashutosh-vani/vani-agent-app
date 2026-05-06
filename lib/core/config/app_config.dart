import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static int get apiTimeout => int.parse(dotenv.env['API_TIMEOUT'] ?? '30000');
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
}
