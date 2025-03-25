import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import '../config/firebase_config.dart';
import 'dart:async';
import 'dart:convert'; // For JSON encoding

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? FirebaseConfig.webClientId : null,
    scopes: ['email', 'profile', 'openid']
  );
  
  // Check if we're using emulator
  bool get _usingEmulator {
    // In debug mode, we assume emulator is being used when configured
    return kDebugMode;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Special handling for emulator
      print("------------------------");
      if (_usingEmulator) {
        print("n\"Using Firebase Auth Emulator for Google Sign-In");
        return await _signInWithGoogleEmulator();
      }
      
      // Regular flow for production
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
  
  // Special method for emulator sign-in
  Future<UserCredential?> _signInWithGoogleEmulator() async {
    try {
      // For emulator, create a properly formatted fake JWT
      // This matches the format that the Auth Emulator expects
      final Map<String, dynamic> header = {
        'alg': 'RS256',
        'kid': 'mock-key-id-for-testing'
      };

      final Map<String, dynamic> payload = {
        'iss': 'https://accounts.google.com',
        'aud': FirebaseConfig.webClientId,
        'auth_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'user_id': 'test-uid-${DateTime.now().millisecondsSinceEpoch}',
        'sub': 'test-uid-${DateTime.now().millisecondsSinceEpoch}',
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        'email': 'test@example.com',
        'email_verified': true,
        'name': 'Test User',
        'picture': 'https://example.com/profile.jpg'
      };

      // Convert header and payload to base64
      String encodeBase64Url(String data) {
        final bytes = utf8.encode(data);
        return base64Url.encode(bytes).replaceAll('=', '');
      }

      final headerBase64 = encodeBase64Url(jsonEncode(header));
      final payloadBase64 = encodeBase64Url(jsonEncode(payload));
      
      // Create JWT (we omit the signature for the emulator)
      final fakeIdToken = '$headerBase64.$payloadBase64.signature';
      
      // Create credential with fake tokens
      final credential = GoogleAuthProvider.credential(
        accessToken: 'mock-access-token-${DateTime.now().millisecondsSinceEpoch}',
        idToken: fakeIdToken,
      );
      
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error in emulator Google sign-in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    if (!_usingEmulator) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}