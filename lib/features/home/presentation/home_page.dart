import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/data/profile_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final email = user?.email ?? '(no email?)';
    final profileAsync = ref.watch(myProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PriceCoco'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
              context.push('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Signed in as: $email'),
            const SizedBox(height: 12),
            profileAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Profile load error: $e',
                  style: const TextStyle(color: Colors.red)),
              data: (row) => Text('Profile row: ${row ?? {}}'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(myProfileProvider),
              child: const Text('Refresh profile'),
            ),
          ],
        ),
      ),
    );
  }
}
