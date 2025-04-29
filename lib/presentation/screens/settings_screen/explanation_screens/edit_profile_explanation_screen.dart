import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class EditProfileExplanationScreen extends StatelessWidget {
  const EditProfileExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.usage_guide)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(data: S.current.edit_profile_screen_description),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/edit_profile_screen.jpg"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }
}