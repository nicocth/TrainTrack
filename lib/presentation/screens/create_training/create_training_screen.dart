import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
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
            onPressed: () {
              if (newTraining.titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.empty_title)),
                );
                return;
              }
              if (newTraining.exercises.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.empty_exercises_list)),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.routine_saved)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input para el título de la rutina
            TextField(
              controller: newTraining.titleController,
              decoration: InputDecoration(labelText: S.current.routine_title),
              onChanged: (value) => trainingNotifier.setTitle(value),
            ),
            const SizedBox(height: 20),

            // Lista de ejercicios en tarjetas personalizadas con botón de agregar al final
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  trainingNotifier.reorderExercise(oldIndex, newIndex);
                },
                children: [
                  for (int index = 0; index < newTraining.exercises.length; index++)
                    ExerciseCard(
                      key: ValueKey(newTraining.exercises[index]), 
                      exercise: newTraining.exercises[index], 
                      onDelete: () => trainingNotifier.removeExercise(index),
                    ),
                ],
              ),
            ),
            // Botón para agregar ejercicio, solo si hay ejercicios en la lista
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(S.current.add_exercise),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExerciseScreen()),
                );
              },
            ),     
          ],
        ),
      ),
    );
  }
}
