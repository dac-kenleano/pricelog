import 'package:flutter/material.dart';
import 'package:pricelog/features/auth/presentation/auth_gate.dart';

class PriceCocoApp extends StatelessWidget {
  const PriceCocoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PriceCoco',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
}
