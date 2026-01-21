import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricelog/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  String? _msg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _msg = null;
    });

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    try {
      final repo = ref.read(authRepositoryProvider);
      if (_isLogin) {
        await repo.signIn(email: email, password: password);
      } else {
        await repo.signUp(email: email, password: password);

        // If email confirmations are ON, session can be null and user must confirm.
        final session = Supabase.instance.client.auth.currentSession;
        if (session == null) {
          setState(() => _msg = 'Check your email to confirm your account.');
        }
      }
    } on AuthException catch (e) {
      setState(() => _msg = e.message);
    } catch (e) {
      setState(() => _msg = 'Something broke: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isLogin ? 'Sign in' : 'Create account';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(title),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loading
                  ? null
                  : () => setState(() {
                        _isLogin = !_isLogin;
                        _msg = null;
                      }),
              child: Text(
                _isLogin ? 'No account? Sign up' : 'Have an account? Sign in',
              ),
            ),
            if (_msg != null) ...[
              const SizedBox(height: 12),
              Text(_msg!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
