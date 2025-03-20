import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_training.dart';
import 'package:train_track/presentation/widgets/shared/finish_training_session_button.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSession = ref.watch(trainingSessionProvider);

    final trainingSessionNotifier = ref.watch(trainingSessionProvider.notifier);

    final sortedExercises = List.of(trainingSession.training!.exercises)
      ..sort((a, b) => a.order.compareTo(b.order));

    // Getting the correct index in the sorted list
    final selectedIndex = trainingSession.selectedExerciseIndex!;

    //Get the selected exercise taking into account the order property, not the position in training
    final selectedExercise = sortedExercises[selectedIndex];

    //The controller are already sorted in provider
    final notesController = trainingSession.notesControllers[selectedIndex];
    final repsControllers = trainingSession.repsControllers[selectedIndex];
    final weightControllers = trainingSession.weightControllers[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(TimeFormatter.formatTime(trainingSession.seconds),
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FinishTrainingSessionButton()),
        ],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise
              ExerciseCardTraining(
                customExercise: selectedExercise,
                notesController: notesController,
                repsControllers: repsControllers,
                weightControllers: weightControllers,
              ),
              const SizedBox(
                  height:
                      10), 
              // button for finish exercise
              Center(
                child: ElevatedButton.icon(
                  label: Text(S.current.finish_exercise),
                  onPressed: () {
                    trainingSessionNotifier.markExerciseCompleted(
                        trainingSession.selectedExerciseIndex!);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
