import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/infraestructure/auth_firebase/auth_storage.dart';  

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
      } else {
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

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Devuelve el usuario registrado
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

  // método para obtener el UID del usuario autenticado
  String? getUserId() {
    return _auth.currentUser?.uid;
  }
}
