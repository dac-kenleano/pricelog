import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(client);
});

final myProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return null;

  return ref.watch(profileRepositoryProvider).getProfile(user.id);
});

class ProfileRepository {
  ProfileRepository(this._client);
  final SupabaseClient _client;

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    return _client.from('profiles').select().eq('id', uid).maybeSingle();
  }

  Future<void> verifyProfileEmail(String uid) async {
    final updated = await _client
        .from('profiles')
        .update({'email_verified': true})
        .eq('id', uid)
        .select()
        .maybeSingle();

    if (updated == null) {
      throw Exception('Failed to update profile for id: $uid');
    }
  }
}
