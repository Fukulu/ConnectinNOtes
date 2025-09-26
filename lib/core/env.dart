import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'http://127.0.0.1:8000');
}