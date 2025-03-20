import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/presentation/screens/complementary_screens/exercise_detail_screen.dart';

class ExerciseName extends ConsumerWidget {
  final CustomExercise customExercise;
  const ExerciseName({super.key, required this.customExercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExerciseDetailScreen(exercise: customExercise.exercise),
            ),
          );
        },
        child: Text(
          customExercise.exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.blue,
        ),
        ),
      ),
    );
  }
}
