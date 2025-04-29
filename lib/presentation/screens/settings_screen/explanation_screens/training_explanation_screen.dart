import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class TrainingExplanationScreen extends StatelessWidget {
  const TrainingExplanationScreen({super.key});

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
              // Explanation of add resume screen
              Text(
                S.current.summary_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/resume.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.summary_description),

              const SizedBox(height: 10),

              // Explanation of exercise selection screen
              Text(
                S.current.exercise_selection_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/exercise_selection.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.exercise_selection_description),

              const SizedBox(height: 10),

              // Explanation of training screen
              Text(
                S.current.training_screen_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/training_screen.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.training_screen_description),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }
}
