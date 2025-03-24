import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_edit.dart';
import 'add_exercise_screen.dart';

class CreateTrainingScreen extends ConsumerWidget {
  final String? trainingId; //optional parameter to edit

  const CreateTrainingScreen({super.key, this.trainingId});

 @override
Widget build(BuildContext context, WidgetRef ref) {
  final newTraining = ref.watch(createTrainingProvider);
  final newTrainingNotifier = ref.read(createTrainingProvider.notifier);

  return Scaffold(
    appBar: AppBar(
      title: Text(trainingId != null ? S.current.edit_routine : S.current.create_routine),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () => _saveTraining(context, ref),
        ),
      ],
    ),
    body: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Training title
            TextField(
              controller: newTraining.titleController,
              decoration: InputDecoration(labelText: S.current.routine_title),
            ),

            const SizedBox(height: 20), // Spacer

            // ExerciseCard list
            ReorderableListView(
              shrinkWrap: true, // Allows the list to fit the content
              physics: const NeverScrollableScrollPhysics(), // Avoid scroll conflicts
              onReorder: (oldIndex, newIndex) {
                newTrainingNotifier.reorderExercise(oldIndex, newIndex);
              },
              children: [
                for (int index = 0; index < newTraining.customExercises.length; index++)
                  ExerciseCard(
                    key: ValueKey(newTraining.customExercises[index]),
                    exerciseIndex: index,
                    customExercise: newTraining.customExercises[index],
                    alternativeController: newTraining.alternativeControllers[index],
                    notesController: newTraining.notesControllers[index],
                    repsControllers: newTraining.repsControllers[index],
                    weightControllers: newTraining.weightControllers[index],
                    onDelete: () {
                      newTrainingNotifier.removeExercise(index);
                    },
                  ),
              ],
            ),

            const SizedBox(height: 20), 

            // Button to add exercises 
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(S.current.add_exercise),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddExerciseScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Future<void> _saveTraining(BuildContext context, WidgetRef ref) async {
    final newTraining = ref.read(createTrainingProvider);

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
      final FirestoreService firestoreService = FirestoreService();
      bool isEditing = trainingId != null;

      final result = isEditing
          ? await firestoreService
              .updateTrainingFromEdit(ref, trainingId!)
              .timeout(Duration(seconds: 6), onTimeout: () {
              throw TimeoutException(S.current
                  .request_timeout); // Add timeout in case the user is left without connection
            })
          : await firestoreService
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
        SnackBar(content: Text(S.current.training_saved)),
      );

      // Return true if the training is success for refresh home
      Navigator.pop(context, true);
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.request_timeout)),
      );
    }
  }
}
