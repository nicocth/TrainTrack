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
            child: ListView.builder(
              itemCount: training.exercises.length,
              itemBuilder: (context, index) {
                final currentExercise = training.exercises[index];
                final nextExercise = index + 1 < training.exercises.length
                    ? training.exercises[index + 1]
                    : null;

                // If there is no next exercise we return the current one
                if (nextExercise == null) {
                  return Column(
                    children: [
                      ExerciseBox(customExercise: currentExercise),
                    ],
                  );
                }
                
                // If the current exercise has a matching alternative with the next one, group them
                if (currentExercise.alternative != null) {
                  if (currentExercise.alternative == nextExercise.alternative) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ExerciseBox(customExercise: currentExercise),
                            SizedBox(width: 16),
                            ExerciseBox(customExercise: nextExercise),
                          ],
                        ),
                        ArrowDown(),
                      ],
                    );
                  }
                } else {
                  // If there's no matching alternative, show each one separately
                  return Column(
                    children: [
                      ExerciseBox(customExercise: currentExercise),
                      ArrowDown(),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
