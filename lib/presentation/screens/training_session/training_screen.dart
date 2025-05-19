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

    // Necessary check since when we end the session having watch it would give a range exception
    if (selectedIndex >= trainingSession.notesControllers.length ||
        selectedIndex >= trainingSession.repsControllers.length ||
        selectedIndex >= trainingSession.weightControllers.length) {
      return Scaffold();
    }

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
              const SizedBox(height: 10),
              // button for finish exercise
              Center(
                child: ElevatedButton.icon(
                  label: Text(S.current.finish_exercise),
                  onPressed: () async {
                    final exerciseOrder =
                        trainingSession.selectedExerciseIndex!;
                    final completedSetsForExercise =
                        trainingSession.completedSets.length > exerciseOrder
                            ? trainingSession.completedSets[exerciseOrder]
                            : <int>{};

                    if (completedSetsForExercise.isEmpty) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(S.current.warning),
                          content: Text(S.current.no_sets_completed_message),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(S.current.finish),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(S.current.cancel),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) {
                        // If the user doesn't confirm, we do nothing
                        return;
                      }
                    }

                    // If there are completed sets or the user confirmed, we mark the exercise as completed and exit
                    trainingSessionNotifier
                        .markExerciseCompleted(exerciseOrder);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
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
