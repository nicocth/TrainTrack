import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_edit.dart';
import 'add_exercise_screen.dart';

class CreateTrainingScreen extends ConsumerWidget {
  const CreateTrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newTraining = ref.watch(trainingProvider);
    final trainingNotifier = ref.read(trainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.create_routine),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveTraining(context, ref),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            //Training title
            TextField(
              controller: newTraining.titleController,
              decoration: InputDecoration(labelText: S.current.routine_title),
            ),

            //Spacer
            const SizedBox(height: 20),

            // ExerciseCard list
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  trainingNotifier.reorderExercise(oldIndex, newIndex);
                },
                children: [
                  for (int index = 0;
                      index < newTraining.customExercises.length;
                      index++)
                    ExerciseCard(
                      key: ValueKey(newTraining.customExercises[index]),
                      exerciseIndex: index,
                      customExercise: newTraining.customExercises[index],
                      notesController: newTraining.notesControllers[index],
                      repsControllers: newTraining.repsControllers[index],
                      weightControllers: newTraining.weightControllers[index],
                      onDelete: () {
                        trainingNotifier.removeExercise(index);
                      },
                    ),
                ],
              ),
            ),

            // Button to add exercises
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(S.current.add_exercise),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddExerciseScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTraining(BuildContext context, WidgetRef ref) async {
    final newTraining = ref.read(trainingProvider);

    // Check title is not empty
    if (newTraining.titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_title)),
      );
      return;
    }

    // Check exercises are not empty
    if (newTraining.customExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_exercises_list)),
      );
      return;
    }

    try {
      // Add timeout in case the user is left without connection
      final result = await FirestoreService()
          .saveTraining(ref)
          .timeout(Duration(seconds: 6), onTimeout: () {
        throw TimeoutException(S.current.request_timeout);
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
      
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.request_timeout)),
      );
    } 
  }
}
