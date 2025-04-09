import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/screens/training_session/exercise_selection_screen.dart';

class TrainingSessionBanner extends ConsumerWidget {
  const TrainingSessionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(trainingSessionProvider);

    if (session.training == null || !session.isRunning) {
      return const SizedBox.shrink();
    }

    return MaterialBanner(
      content: Text(S.current.training_in_progress),
      leading: const Icon(Icons.fitness_center),
      backgroundColor: Colors.black,
      dividerColor: Colors.transparent,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseSelectionScreen()),
            );
          },
          child: Text(S.current.back_to_training),
        ),
        TextButton(
          onPressed: () {
            // Discard session
            ref.read(trainingSessionProvider.notifier).resetSession();
          },
          child: Text(S.current.discard),
        ),
      ],
    );
  }
}
