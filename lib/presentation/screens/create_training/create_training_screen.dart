import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';

import 'add_exercise_screen.dart'; // Pantalla para agregar ejercicios

class CreateTrainingScreen extends ConsumerWidget {
  const CreateTrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newTraining = ref.watch(trainingProvider);
    final trainingNotifier = ref.read(trainingProvider.notifier);
    final TextEditingController titleController = TextEditingController(text: newTraining.title);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rutina'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
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
              controller: titleController,
              decoration: InputDecoration(labelText: S.current.routine_title),
              onChanged: (value) => trainingNotifier.setTitle(value),
            ),
            const SizedBox(height: 20),

            // Lista de ejercicios agregados
            Expanded(
              child: ListView.builder(
                itemCount: newTraining.exercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(newTraining.exercises[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => trainingNotifier.removeExercise(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Botón para ir a agregar ejercicios
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Agregar Ejercicio"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExerciseScreen()),
                );
              },
            ),

            const SizedBox(height: 10),

            // Botón para guardar la rutina
            ElevatedButton(
              onPressed: () {
                if (newTraining.title.isEmpty) {
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
                // Guardar en Firestore o localmente
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.routine_saved)),
                );
              },
              child: Text(S.current.save_routine),
            ),
          ],
        ),
      ),
    );
  }
}
