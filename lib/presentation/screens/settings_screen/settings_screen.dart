import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // check if user is logged in
    // only perform the check on this screen since it is the only one with the logout function.
    final user = ref.watch(authProvider); 

    // if user is null, redirect to login screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // delete all routes
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
          )
        ],
      ),
      body: const Center(
        child: Text('Bienvenido a Settings Screen'),
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) async {
    try{
      await ref.read(authProvider.notifier).signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cerrar sesión'),
        ),
      );
    }
  }
}
