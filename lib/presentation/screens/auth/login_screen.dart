import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/auth/register_screen.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/infraestructure/auth_firebase/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void login(BuildContext context) async {
    final userCredential = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (userCredential != null) {
      // login success
      Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen()), 
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.current.login_failed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: S.current.email),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: S.current.password),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authProvider.notifier).signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  String errorMessage = S.current.login_failed;;

                  if (e is FirebaseAuthException) {
                    switch (e.code) {
                      case 'user-not-found':
                        errorMessage = S.current.user_not_found;
                        break;
                      case 'wrong-password':
                        errorMessage = S.current.wrong_password;
                        break;
                      case 'invalid-email':
                        errorMessage = S.current.invalid_email;
                        break;
                      case 'user-disabled':
                        errorMessage = S.current.user_disabled;
                        break;
                      default:
                        errorMessage = S.current.login_failed;	
                    }
                  }

                  // mostrar el mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(S.current.login),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                S.current.access_register,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
