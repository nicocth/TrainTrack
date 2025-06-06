import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';
import 'package:train_track/infraestructure/auth_firebase/auth_provider.dart';
import 'package:train_track/core/utils/validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _togglePasswordConfirmationVisibility() {
    setState(() {
      _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_login.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            // Gradient overlay
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              color: Color.fromRGBO(0, 0, 0, 0.4),
              alignment: Alignment.center,
              child: Text(
                // App name
                S.current.traintrack,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Form container
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                  child: 
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
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
                            decoration: InputDecoration(
                              labelText: S.current.email,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: S.current.password,
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscurePasswordConfirmation,
                            decoration: InputDecoration(
                              labelText: S.current.confirm_password,
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePasswordConfirmation
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: _togglePasswordConfirmationVisibility,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02),
                          ElevatedButton(
                            onPressed: () => register(context),
                            child: Text(S.current.register),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              S.current.already_have_account,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void register(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!Validators.emptyfieldsRegister(email, password, confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.current.fill_all_fields),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (!Validators.validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.current.invalid_email),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (!Validators.validatePassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.current.weak_password),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (!Validators.comparePassword(password, confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.current.passwords_do_not_match),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final user =
          await ref.read(authProvider.notifier).signUp(email, password);

      if (user == null) {
        throw FirebaseAuthException(code: 'user-creation-failed');
      }

      final result =
          await FirestoreService().createUserInFirestore(email, user.uid);

      //check if widget is mounted before displaying snackbar
      if (!context.mounted) return;

      // check if creation db is failure
      if (result.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result.errorMessage ?? S.current.uknown_error),
              backgroundColor: Colors.red),
        );
        return;
      }

      //if the result is success navegate to home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      String errorMessage = S.current.registration_failed;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = S.current.email_already_in_use;
            break;
          case 'invalid-email':
            errorMessage = S.current.invalid_email;
            break;
          case 'weak-password':
            errorMessage = S.current.weak_password;
            break;
          default:
            errorMessage = S.current.registration_failed;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
}
