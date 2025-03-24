import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await _authService.signInWithGoogle();
      
      // Check if we're still mounted before updating state
      if (!mounted) return;

      // Clear loading state
      setState(() {
        _isLoading = false;
      });

      if (credential == null) {
        _showErrorDialog('Sign in was cancelled or failed. Please try again.');
      }
      // If successful, AuthWrapper will automatically navigate
      
    } catch (e) {
      print('Login error: $e');
      
      // Check if we're still mounted before updating state
      if (!mounted) return;

      // Clear loading state
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An error occurred during sign in: ${e.toString()}');
    }
  }

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
              
              // Show either loading indicator or login button
              _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                    ),
                    onPressed: _handleSignIn,
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
                            colorFilter: null,
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