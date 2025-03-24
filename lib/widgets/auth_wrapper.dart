import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../ui/screens/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _showLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // Check auth state immediately to avoid flicker
    _checkInitialAuthState();
  }

  // Check auth state once on startup
  Future<void> _checkInitialAuthState() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    
    // Small delay to avoid UI glitches
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (mounted) {
      setState(() {
        _showLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initial loading state (only on first app launch)
    if (_showLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // After initial load, use stream for auth changes
    // but don't show loading indicator during transitions
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Use current user state instead of snapshot when transitioning
        final user = snapshot.data;
        
        if (user == null) {
          return const LoginScreen();
        }
        
        return widget.child;
      },
    );
  }
}