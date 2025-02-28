import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/auth/register_screen.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/core/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_login.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              color: Color.fromRGBO(0, 0, 0, 0.4),
              alignment: Alignment.center,
              child: Text(
                'TrainTrack',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: S.current.email,
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: S.current.password,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => login(context),
                    child: Text(S.current.login),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      S.current.access_register,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login method
  void login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;


    if (!Validators.emptyfields(email, password)) {	
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.fill_all_fields), backgroundColor: Colors.red),
      );
      return;
    }

    if (!Validators.validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.invalid_email), backgroundColor: Colors.red),
      );
      return;
    }

    if (!Validators.validatePassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.weak_password), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      await ref.read(authProvider.notifier).signIn(email, password);

      //check if widget is mounted before displaying snackbar
      if (!context.mounted) return;
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      String errorMessage = S.current.login_failed;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
}
