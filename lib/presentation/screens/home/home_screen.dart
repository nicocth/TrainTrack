import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/shared/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
          )
        ],
      ),
      body: const Center(
        child: Text('Bienvenido a Home Screen'),
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
