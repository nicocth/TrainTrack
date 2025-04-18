import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/widgets/shared/finish_training_session_button.dart';
import 'package:train_track/presentation/widgets/shared/training_diagram.dart';

class ExerciseSelectionScreen extends ConsumerWidget {
  const ExerciseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSession = ref.watch(trainingSessionProvider);
    final Training training = trainingSession.training!;

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
          TrainingDiagram(training: training, selectableExerciseBox: true)
        ],
      ),
    );
  }
}
