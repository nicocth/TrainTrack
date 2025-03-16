import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/screens/training_session/exercise_selection_screen.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_training.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({ super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSession =
        ref.watch(trainingSessionProvider); 

    final trainingSessionNotifier =
        ref.watch(trainingSessionProvider.notifier); 
    final selectedExercise = trainingSession.training!.exercises[trainingSession.selectedExerciseIndex!];
    final notesController = trainingSession.notesControllers[trainingSession.selectedExerciseIndex!];
    final repsControllers = trainingSession.repsControllers[trainingSession.selectedExerciseIndex!];
    final weightControllers = trainingSession.weightControllers[trainingSession.selectedExerciseIndex!];

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
            child: ElevatedButton.icon(
              label: Text(S.current.finish),
              onPressed: () {
                //TODO: implementar finalización de sesion
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
        
            // Exercise 
            ExerciseCardTraining(customExercise: selectedExercise, notesController: notesController, repsControllers: repsControllers, weightControllers: weightControllers),

            // button for finish exercise
            ElevatedButton.icon(
              label: Text(S.current.finish_exercise),
              onPressed: () {
                
                trainingSessionNotifier.markExerciseCompleted(trainingSession.selectedExerciseIndex!);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseSelectionScreen(training: trainingSession.training!)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
