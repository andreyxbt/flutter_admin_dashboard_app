import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 2,
                ),
                onPressed: () async {
                  final credential = await _authService.signInWithGoogle();
                  if (credential != null && context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/dashboard');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/icons/google_g_logo.svg',
                        width: 24,
                        height: 24,
                        colorFilter: null, // Ensure original colors are preserved
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Sign in with Google'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}