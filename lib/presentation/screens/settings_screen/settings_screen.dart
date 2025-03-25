import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/edit_profile_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/statistics_screen.dart';

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
        title: Text(S.current.app_bar_settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.current.account,
                style: Theme.of(context).textTheme.bodyLarge),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: Text(S.current.statistics),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StatisticsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(S.current.account),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            Text(S.current.preferences,
                style: Theme.of(context).textTheme.bodyLarge),
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text(S.current.language),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              enabled: false,
              onTap: () {
                //TODO: Navigate to the language screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(S.current.mode),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              enabled: false,
              onTap: () {
                //TODO: Navigate to dark/light mode screen
              },
            ),
            SizedBox(height: 20),
            Text(S.current.help, style: Theme.of(context).textTheme.bodyLarge),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(S.current.help),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              enabled: false,
              onTap: () {
                //TODO: Navigate to help screen
              },
            ),
            SizedBox(height: 20),
            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _logout(context, ref),
                child: Text(S.current.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signOut();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.current.logout_failed),
        ),
      );
    }
  }
}
