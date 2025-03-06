import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';
import 'package:train_track/presentation/widgets/shared/arrow_down.dart';
import 'package:train_track/presentation/widgets/shared/exercise_box.dart';
import 'package:train_track/presentation/widgets/shared/training_chart.dart';

class TrainingSummaryScreen extends ConsumerWidget {
  final Training training;
  const TrainingSummaryScreen({required this.training, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.summary),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              })
        ],
      ),
      body: Column(
        children: [
          // Routine name
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(training.name,
                  style: Theme.of(context).textTheme.headlineSmall)),

          // Chart
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TrainingChart(),
          ),

          // Exercise list title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.exercises,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
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
                      return const SizedBox
                          .shrink(); 
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
                        currentExercise.alternative == nextExercise.alternative) {
                      skippedIndexes.add(
                          nextIndex); // We avoid rendering nextExercise later
                      exerciseWidget = Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ExerciseBox(customExercise: currentExercise),
                          const SizedBox(width: 16),
                          ExerciseBox(customExercise: nextExercise),
                        ],
                      );
                    } else {
                      exerciseWidget =
                          ExerciseBox(customExercise: currentExercise);
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
}
