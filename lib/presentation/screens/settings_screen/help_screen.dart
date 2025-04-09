import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
              // Explanation of Home screen
              Text(
                S.current.home_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/home.png"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.home_description),

              const SizedBox(height: 10),

              // Explanation of creating training 1
              Text(
                S.current.create_training_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/create_training_empty.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.create_training_description_1),

              const SizedBox(height: 10),

              // Explanation of add exercise screen
              Text(
                S.current.add_exercise_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/add_exercise.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.add_exercise_description),

              // Explanation of creating training 2
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/create_training.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.create_training_description_2),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/exercise_detail.jpg"),
                ),
              ),

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

              const SizedBox(height: 10),

              // Explanation of statistics screen
              Text(
                S.current.statistics_screen_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/statistics_screen.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.statistics_screen_description),

              const SizedBox(height: 10),

              // Explanation of edit profile screen
              Text(
                S.current.edit_profile_screen_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/edit_profile_screen.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Html(data: S.current.edit_profile_screen_description),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }
}
