import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/shared/services/auth_storage.dart';  

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null) {
    _init();
  }  

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthStorage _storage = AuthStorage();

  Future<void> _init() async {
    _auth.authStateChanges().listen((User? user) {
      state = user;
      if (user != null) {
        user.getIdToken().then((token) {
          _storage.saveToken(token!);
        });
      }else {
        _storage.deleteToken();
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}