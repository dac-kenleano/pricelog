import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => _required('SUPABASE_URL');
  static String get supabaseAnonKey => _required('SUPABASE_ANON_KEY');

  static String _required(String key) {
    final v = dotenv.env[key];
    if (v == null || v.isEmpty) {
      throw StateError('Missing env var: $key');
    }
    return v;
  }
}
