import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../core/providers/supabase_providers.dart';

class _StreamNotifier extends ChangeNotifier {
  _StreamNotifier(Stream<dynamic> stream, {this.onEvent}) {
    _sub = stream.listen((_) {
      onEvent?.call();
      notifyListeners();
    }, onError: (_) => notifyListeners());
  }

  StreamSubscription? _sub;
  final VoidCallback? onEvent;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  // Watch the Supabase client directly and use its auth stream as the notifier source.
  final client = ref.watch(supabaseClientProvider);
  final authStream = client.auth.onAuthStateChange;

  // Create a ChangeNotifier that notifies whenever the auth stream emits, so GoRouter can refresh.
  final refreshListenable = _StreamNotifier(
    authStream,
    onEvent: () {
      // Invalidate the currentUserProvider so the redirect reads the updated user
      ref.invalidate(currentUserProvider);
    },
  );
  ref.onDispose(() => refreshListenable.dispose());

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'auth',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      // If auth stream hasn't emitted yet, don't redirect (prevents races right after sign-in)
      final authAsync = ref.read(authStateChangesProvider);
      if (authAsync.isLoading) return null;

      // Read current user synchronously from provider.
      final user = ref.read(currentUserProvider);
      final loc = state.uri.path; // use uri.path for compatibility
      final loggingIn = loc == '/login' || loc == '/register' || loc == '/';

      if (user == null) {
        // Not signed in: if not on login/register, go to login.
        return loggingIn ? null : '/login';
      }

      // Signed in: avoid landing on auth pages
      if (loggingIn) return '/home';

      // No redirect
      return null;
    },
  );

  return router;
});
