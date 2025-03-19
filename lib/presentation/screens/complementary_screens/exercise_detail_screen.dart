import 'package:flutter/material.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/generated/l10n.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.exercise_setail_title)),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(exercise.image),
            ),
            const SizedBox(height: 20),
            Text(
              exercise.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(exercise.description),
          ],
        ),
      ),
    );
  }
}
