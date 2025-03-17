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
            //Close popup
            onPressed: () => Navigator.pop(context),
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () async {
              //Close popup and finish training

              try {
                final FirestoreService firestoreService = FirestoreService();
                final trainingSession = ref.watch(trainingSessionProvider);
                final trainingId = trainingSession.training!.id;
                
                final result = await firestoreService
                    .updateTrainingFromTrainingSession(ref, trainingId)
                    .timeout(Duration(seconds: 6), onTimeout: () {
                  throw TimeoutException(S.current
                      .request_timeout); // Add timeout in case the user is left without connection
                });

                //check if widget is mounted before displaying snackbar
                if (!context.mounted) return;

                if (result.isFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.current.error_saving_routine)),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.routine_saved)),
                );

                // Return true if the training is success for refresh home
                Navigator.pop(context, true);
              } on TimeoutException {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.request_timeout)),
                );
              }

              ref.read(trainingSessionProvider.notifier).resetSession();

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: Text(S.current.finish,
                style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
