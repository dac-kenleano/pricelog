import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});

class AuthRepository {
  AuthRepository(this._client);
  final SupabaseClient _client;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'displayName': email.split('@').first,
      },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
