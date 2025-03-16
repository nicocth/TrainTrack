import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';
import 'package:train_track/presentation/screens/training_session/exercise_selection_screen.dart';
import 'package:train_track/presentation/widgets/shared/training_chart.dart';
import 'package:train_track/presentation/widgets/shared/training_diagram.dart';

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
          TrainingDiagram(training: training, exerciseBox: true),

          // Button to start training session
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              label: Text(S.current.start_training),
              onPressed: () {
                final trainingSessionNotifier =
                    ref.read(trainingSessionProvider.notifier);
                trainingSessionNotifier.startSession(training);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseSelectionScreen(training: training)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
