import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';

class FinishTrainingSessionButton extends ConsumerWidget {
  const FinishTrainingSessionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      label: Text(S.current.finish),
      onPressed: () {
        _showFinishConfirmationDialog(context, ref);
      },
    );
  }

  void _showFinishConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.confirm_finish_training),
        content: Text(S.current.confirm_finish_message_training),
        actions: [
          TextButton(
            onPressed: () async {
              _showUpdateRoutineDialog(context, ref);
            },
            child: Text(S.current.finish,
                style: const TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.current.cancel),
          ),
        ],
      ),
    );
  }

  void _showUpdateRoutineDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.update_training_alert),
        content: Text(S.current.update_training_message),
        actions: [
          TextButton(
            onPressed: () => _finishTraining(context, ref, updateRoutine: true),
            child: Text(S.current.yes),
          ),
          TextButton(
            onPressed: () =>
                _finishTraining(context, ref, updateRoutine: false),
            child: Text(S.current.no),
          ),
        ],
      ),
    );
  }

  Future<void> _finishTraining(BuildContext context, WidgetRef ref,
      {required bool updateRoutine}) async {
    try {
      final FirestoreService firestoreService = FirestoreService();
      final trainingSession = ref.watch(trainingSessionProvider);
      final trainingId = trainingSession.training!.id;

      // If the user wants, the training is updated
      if (updateRoutine) {
        final result = await firestoreService
            .updateTrainingFromTrainingSession(ref, trainingId)
            .timeout(Duration(seconds: 6), onTimeout: () {
          throw TimeoutException(S.current.request_timeout);
        });

        if (!context.mounted) return;

        if (result.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.current.error_saving_routine)),
          );
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(updateRoutine
                ? S.current.training_updated_saved
                : S.current.training_saved)),
      );

      // Reset the training session and navigate to home
      ref.read(trainingSessionProvider.notifier).resetSession();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.request_timeout)),
      );
    }
  }
}
