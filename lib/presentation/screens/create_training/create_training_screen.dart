import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_edit.dart';
import 'add_exercise_screen.dart';

class CreateTrainingScreen extends ConsumerWidget {
  const CreateTrainingScreen({super.key});

  Future<void> _saveTraining(BuildContext context, WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    final newTraining = ref.watch(trainingProvider);
    final userId = authNotifier.getUserId();

    if (newTraining.titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_title)),
      );
      return;
    }

    if (newTraining.customExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_exercises_list)),
      );
      return;
    }

    try {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(userId);
      final routinesRef = userRef.collection('rutinas');

      // Crear nueva rutina
      final routineDoc = await routinesRef.add({
        'nombre': newTraining.titleController.text,
        'fecha_creacion': Timestamp.now(),
        'ultima_actualizacion': Timestamp.now(),
      });

      // Agregar ejercicios dentro de la rutina
      for (var customExercise in newTraining.customExercises) {
        await routineDoc.collection('ejercicios').add({
          'ejercicio': customExercise.exercise.id,
          'nombre': customExercise.exercise.name, 
          'notas': customExercise.notes,
          'series': customExercise.sets.map((set) => {
            'peso': set.weight,
            'repeticiones': set.reps,
          }).toList(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.routine_saved)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.error_saving_routine)),
      );
    }
  }

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
                  for (int index = 0; index < newTraining.customExercises.length; index++)
                    ExerciseCard(
                      key: ValueKey(newTraining.customExercises[index]),
                      customExercise: newTraining.customExercises[index],
                      onDelete: () => trainingNotifier.removeExercise(index),
                    ),
                ],
              ),
            ),
            // Botón para agregar ejercicio
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
