import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/presentation/widgets/shared/arrow_down.dart';
import 'package:train_track/presentation/widgets/shared/exercise_box.dart';
import 'package:train_track/presentation/widgets/shared/selectable_exercise_box.dart';

class TrainingDiagram extends ConsumerWidget {
  final Training training;
  final bool? exerciseBox;
  final bool? selectableExerciseBox;

  const TrainingDiagram({
    this.selectableExerciseBox = false,
    this.exerciseBox = false,
    required this.training,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Builder(
        builder: (context) {
          // Exercises are ordered before they are shown
          final sortedExercises = List.from(training.exercises)
            ..sort((a, b) => a.order.compareTo(b.order));

          // Set to avoid duplicates
          final Set<int> skippedIndexes = {};

          return ListView.builder(
            itemCount: sortedExercises.length,
            itemBuilder: (context, index) {
              // We avoid rendering duplicates
              if (skippedIndexes.contains(index)) {
                return const SizedBox.shrink();
              }

              final currentExercise = sortedExercises[index];
              final nextIndex = index + 1;
              final nextExercise = nextIndex < sortedExercises.length
                  ? sortedExercises[nextIndex]
                  : null;

              Widget exerciseWidget;

              // If the current year and the following year have the same alternative, we group them
              if (nextExercise != null &&
                  currentExercise.isAlternative &&
                  currentExercise.alternative == nextExercise.alternative) {
                // We avoid rendering nextExercise after
                skippedIndexes.add(nextIndex);

                exerciseWidget = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getExerciseBox(
                          currentExercise), 
                      const SizedBox(width: 16),
                      _getExerciseBox(
                          nextExercise),
                    ],
                  ),
                );
              } else {
                exerciseWidget = _getExerciseBox(
                    currentExercise);
              }

              // Check if there are more exercises after the current one to show the arrow
              final hasNextExercise = sortedExercises.skip(index + 1).any(
                  (e) => !skippedIndexes.contains(sortedExercises.indexOf(e)));

              return Column(
                children: [
                  exerciseWidget,
                  if (hasNextExercise)
                    ArrowDown(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Function that returns the appropriate widget depending on the parameters received
  Widget _getExerciseBox(CustomExercise exercise) {
    if (selectableExerciseBox == true) {
      return SelectableExerciseBox(customExercise: exercise);
    } else if (exerciseBox == true) {
      return ExerciseBox(customExercise: exercise);
    } else {
      return SizedBox
          .shrink(); // If no widget is provided, an empty size is displayed
    }
  }
}
