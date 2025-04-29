import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class CreateTrainingExplanationScreen extends StatelessWidget {
  const CreateTrainingExplanationScreen({super.key});

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
              // Explanation of exercise detail screen
              Html(data: S.current.exercise_detail_description),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/exercise_detail.jpg"),
                ),
              ),
              // Explanation of creating training 3
              Html(data: S.current.create_training_description_3),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }
}
