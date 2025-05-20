import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:train_track/core/utils/validators.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/training_history_screen.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final User user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  // Detect if the user is a Google user
  late bool _isGoogleUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(S.current.edit_profile)),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: S.current.email),
                  enabled: false,
                ),
                // If the user is not a Google user, show the password fields
                if (!_isGoogleUser) ...[
                  TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(labelText: S.current.nickname),
                  ),
                ] else ...[
                  TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(labelText: S.current.nickname),
                    enabled: false,
                  ),
                ],

                if (!_isGoogleUser) ...[
                  SizedBox(height: 20),
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text(S.current.update_nickname),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _currentPasswordController,
                    decoration:
                        InputDecoration(labelText: S.current.current_password),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _newPasswordController,
                    decoration:
                        InputDecoration(labelText: S.current.new_password),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: _updatePassword,
                      child: Text(S.current.update_password),
                    ),
                  ),
                ],
                SizedBox(height: 20),
                // button to delete statistics
                SizedBox(
                  width: 240,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _confirmDeleteHistory,
                    child: Text(S.current.delete_history),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 240,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _confirmDeleteAccount,
                    child: Text(S.current.delete_account),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const TrainingSessionBanner(),
      ),
    );
  }

  Future<void> _loadUserData() async {
    _isGoogleUser =
        user.providerData.any((info) => info.providerId == 'google.com');

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        if (_isGoogleUser) {
          _nicknameController.text = user.displayName ?? '';
        } else {
          _nicknameController.text = data['nickname'] ?? '';
        }
        _emailController.text = user.email ?? '';
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.update({
        'nickname': _nicknameController.text.trim(),
      }).timeout(Duration(seconds: 6), onTimeout: () {
        throw TimeoutException(S.current.request_timeout);
      });

      // Check if widget is mounted before displaying snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.nickname_updated)),
        );
      }
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.request_timeout)),
        );
      }
    }
  }

  Future<void> _updatePassword() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      if (_currentPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.current_password_empty)),
        );
        return;
      }

      if (!Validators.validatePassword(_newPasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(S.current.weak_password),
              backgroundColor: Colors.red),
        );
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPasswordController.text.trim()).timeout(
        Duration(seconds: 6),
        onTimeout: () {
          throw TimeoutException(S.current.request_timeout);
        },
      );

      //Clear the password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();

      // Check if widget is mounted before displaying snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.password_updated)),
        );
      }
    } on FirebaseAuthException {
      // Check if widget is mounted before displaying snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.wrong_current_password)),
        );
      }
    } on TimeoutException {
      // Check if widget is mounted before displaying snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.request_timeout)),
        );
      }
    } catch (e) {
      // Handle other exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (_isGoogleUser) {
        await _reauthenticateWithGoogle();
      } else {
        if (_currentPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.current.current_password_empty)),
          );
          return;
        }

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);
      }

      // Delete user document in Firestore
      final result = await FirestoreService().deleteDocCurrentUser(ref);

      // Delete the Firebase Authentication account
      await user.delete();

      // Check if widget is mounted before navigating away
      if (result.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.current.account_deleted)),
          );
          // Navigate to the login screen after deleting the account
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.errorMessage ?? 'Error')),
          );
        }
      }
    } on FirebaseAuthException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.wrong_current_password)),
        );
      }
    }
  }

  Future<void> _deleteHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (_isGoogleUser) {
        await _reauthenticateWithGoogle();
      } else {
        if (_currentPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.current.current_password_empty)),
          );
          return;
        }

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);
      }

      // Delete training history document in Firestore
      final result =
          await FirestoreService().deleteTrainingHistory(ref).timeout(
        Duration(seconds: 6),
        onTimeout: () {
          throw TimeoutException(S.current.request_timeout);
        },
      );

      if (result.isSuccess) {
        // Clear the password field
        _currentPasswordController.clear();

              // Invalidate the training history provider to refresh the data
      ref.invalidate(trainingHistoryProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.current.history_deleted)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.errorMessage ?? 'Error')),
          );
        }
      }
    } on FirebaseAuthException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.wrong_current_password)),
        );
      }
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.request_timeout)),
        );
      }
    } catch (e) {
      // Handle other exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.current.confirm_delete),
              content: Text(S.current.delete_account_confirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(S.current.delete),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(S.current.cancel),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      await _deleteAccount();
    }
  }

  Future<void> _confirmDeleteHistory() async {
    final bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.current.confirm_delete),
              content: Text(S.current.delete_history_confirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(S.current.delete),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(S.current.cancel),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      await _deleteHistory();
    }
  }

  Future<void> _reauthenticateWithGoogle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);
  }
}
