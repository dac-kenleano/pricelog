import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';

class PriceCocoApp extends ConsumerWidget {
  const PriceCocoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'PriceCoco',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}
