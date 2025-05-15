import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/settings_screen/explanation_screens/create_training_explanation_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/explanation_screens/edit_profile_explanation_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/explanation_screens/home_explanation_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/explanation_screens/statistics_explanation_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/explanation_screens/training_explanation_screen.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.usage_guide),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(S.current.home_explanation),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeExplanationScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(S.current.create_training),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CreateTrainingExplanationScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(S.current.register_training),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TrainingExplanationScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text("Editar perfil"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const EditProfileExplanationScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(S.current.statistics),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const StatisticsExplanationScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const TrainingSessionBanner(),
      ),
    );
  }
}
