import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/screens/training_session/training_screen.dart';

class SelectableExerciseBox extends ConsumerWidget {
  final CustomExercise customExercise;
  const SelectableExerciseBox({required this.customExercise, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSessionState = ref.watch(trainingSessionProvider);

    // Check if the exercise is marked as completed
    final isCompleted =
        trainingSessionState.completedExercises.contains(customExercise.order);

    return GestureDetector(
      onTap: () {
        _selectExercise(context, ref);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    customExercise.exercise.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    customExercise.exercise.name,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Checkbox(
              value: isCompleted,
              onChanged: (value) {
                _selectExercise(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

//The code is used twice to prioritize the user experience and so that it doesn't matter if they click
//on the container or the check box, it works the same.
  void _selectExercise(BuildContext context, WidgetRef ref) {
    final trainingSessionNotifier = ref.read(trainingSessionProvider.notifier);

    trainingSessionNotifier.selectExercise(customExercise.order);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrainingScreen()),
    );
  }
}
