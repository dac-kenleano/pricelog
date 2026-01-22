import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../home/presentation/home_page.dart';
import 'login_page.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  StreamSubscription? _sub;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();

    // Handle initial deep link
    handleDeepLink();

    // Handle deep links while the app is running
    _sub = _appLinks.uriLinkStream.listen((uri) {
      // call handler directly; `uri` is non-nullable from the stream's type
      handleDeepLink(uri: uri);
    }, onError: (_) {});
  }

  Future<void> handleDeepLink({Uri? uri}) async {
    try {
      final incoming = uri ?? await _appLinks.getInitialLink();
      if (incoming == null) return;

      await Supabase.instance.client.auth.getSessionFromUrl(incoming);

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).popUntil((r) => r.isFirst);
        });
      }
    } catch (_) {
      // ignore deep link errors
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
      data: (_) {
        final user = ref.watch(currentUserProvider);
        if (user == null) return const LoginPage();
        return const HomePage();
      },
    );
  }
}
