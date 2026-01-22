import 'dart:io';

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
    final redirect = Platform.isAndroid || Platform.isIOS
        ? 'pricecoco://login-callback'
        : 'https://yizxrjiyltdkhgdivhwq.supabase.co/auth/v1/callback';

    return _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: redirect,
      data: {
        'display_name': email.split('@').first,
      },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
