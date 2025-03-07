import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/session_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/arrow_down.dart';
import 'package:train_track/presentation/widgets/shared/selectable_exercise_box.dart';

class ExerciseSelectionScreen extends ConsumerWidget {
  final Training training;
  const ExerciseSelectionScreen({required this.training, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session =
        ref.watch(sessionTrainingProvider); // Lee el estado del timer

    return Scaffold(
      appBar: AppBar(

        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(formatTime(session.seconds),
                style: Theme.of(context).textTheme.headlineSmall),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              label: Text(S.current.finish),
              onPressed: () {
                //TODO: implementar finalización de sesion
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(15),
            child: Text(S.current.select_exercise,
                style: Theme.of(context).textTheme.bodyLarge),
          ),

          // Exercise list
          Expanded(
            child: Builder(
              builder: (context) {
                // We order the exercises before showing them
                final sortedExercises = List.from(training.exercises)
                  ..sort((a, b) => a.order.compareTo(b.order));

                // Set to avoid duplication
                final Set<int> skippedIndexes = {};

                return ListView.builder(
                  itemCount: sortedExercises.length,
                  itemBuilder: (context, index) {
                    // Avoid rendering duplicates
                    if (skippedIndexes.contains(index)) {
                      return const SizedBox.shrink();
                    }

                    final currentExercise = sortedExercises[index];
                    final nextIndex = index + 1;
                    final nextExercise = nextIndex < sortedExercises.length
                        ? sortedExercises[nextIndex]
                        : null;

                    Widget exerciseWidget;

                    // If the current exercise and the next have the same alternative, we group them
                    if (nextExercise != null &&
                        currentExercise.isAlternative &&
                        currentExercise.alternative ==
                            nextExercise.alternative) {
                      skippedIndexes.add(
                          nextIndex); // We avoid rendering nextExercise later
                      exerciseWidget = SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableExerciseBox(customExercise: currentExercise),
                            const SizedBox(width: 16),
                            SelectableExerciseBox(customExercise: nextExercise),
                          ],
                        ),
                      );
                    } else {
                      exerciseWidget =
                          SelectableExerciseBox(customExercise: currentExercise);
                    }

                    // We check if there are more exercises after the current one to show the arrow
                    final hasNextExercise = sortedExercises.skip(index + 1).any(
                        (e) => !skippedIndexes
                            .contains(sortedExercises.indexOf(e)));

                    return Column(
                      children: [
                        exerciseWidget,
                        if (hasNextExercise)
                          ArrowDown(), // We only show the arrow if there are more exercises
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
