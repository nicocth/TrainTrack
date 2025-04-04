import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_track/core/utils/validators.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';

//TODO: refactor and modularize this screen

final userProvider = StateProvider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _updateProfile() async {
    final user = ref.read(userProvider);
    if (user == null) return;
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.update({
        'nickname': _nicknameController.text.trim(),
      }).timeout(Duration(seconds: 3), onTimeout: () {
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
      await user.updatePassword(_newPasswordController.text.trim());

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
    }
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.current_password_empty)),
      );
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);
      // Delete user document in Firestore
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.delete();

      // Delete the Firebase Authentication account
      await user.delete();

      // Check if widget is mounted before navigating away
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
    } on FirebaseAuthException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.wrong_current_password)),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = ref.read(userProvider);
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        _nicknameController.text = data['nickname'] ?? '';
        _emailController.text = user.email ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: S.current.nickname),
              ),
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
                decoration: InputDecoration(labelText: S.current.new_password),
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
              SizedBox(height: 20),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _confirmDeleteAccount,
                  child: Text(S.current.delete_account),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
