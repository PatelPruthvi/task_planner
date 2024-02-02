import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the user is already signed in
  Future<User?> get currentUser async {
    return _auth.currentUser;
  }

  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      // Save authentication state
      await _saveAuthState(true);

      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Error during anonymous sign-in: $e");
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    // Clear authentication state
    await _saveAuthState(false);
  }

  // Save authentication state to local storage
  Future<void> _saveAuthState(bool isAuthenticated) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthenticated', isAuthenticated);
  }

  // Check authentication state on app start
  Future<bool> checkAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }
}
