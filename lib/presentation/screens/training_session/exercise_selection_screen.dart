import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/session_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/training_diagram.dart';

class ExerciseSelectionScreen extends ConsumerWidget {
  final Training training;
  const ExerciseSelectionScreen({required this.training, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session =
        ref.watch(sessionTrainingProvider); 

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(TimeFormatter.formatTime(session.seconds), 
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
          TrainingDiagram(training: training, selectableExerciseBox: true)
        ],
      ),
    );
  }
}
