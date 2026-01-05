import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});


class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.loading()) {
    _init();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _init() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          await user.reload();
          state = AuthState.authenticated(_auth.currentUser!);
        } catch (_) {
          await signOut();
          state = AuthState.unauthenticated();
        }
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<User?> signUp(String email, String password) async {
    final userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String? getUserId() => _auth.currentUser?.uid;
}


class AuthState {
  final User? user;
  final bool isLoading;

  const AuthState({
    required this.user,
    required this.isLoading,
  });

  factory AuthState.loading() =>
      const AuthState(user: null, isLoading: true);

  factory AuthState.authenticated(User user) =>
      AuthState(user: user, isLoading: false);

  factory AuthState.unauthenticated() =>
      const AuthState(user: null, isLoading: false);
}
