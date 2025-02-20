import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
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


// Tarjeta personalizada para cada ejercicio
class ExerciseCard extends StatefulWidget {
  final dynamic exercise;
  final VoidCallback onDelete;

  const ExerciseCard({Key? key, required this.exercise, required this.onDelete}) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>> series = []; // Lista de series (KG y reps)

  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección superior con imagen, nombre y menú de opciones
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.exercise.imagen,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.exercise.nombre,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Eliminar"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 10),

            // Campo de notas
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Notas",
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),

            const SizedBox(height: 10),

            // Tabla de series
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Serie", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("KG", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Reps", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                Column(
                  children: List.generate(series.length, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("#${index + 1}"),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              series[index]['kg'] = double.tryParse(value) ?? 0;
                            },
                            decoration: const InputDecoration(hintText: "Kg"),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              series[index]['reps'] = int.tryParse(value) ?? 0;
                            },
                            decoration: const InputDecoration(hintText: "Reps"),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              series.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),

            // Botón para agregar series
            TextButton.icon(
              onPressed: () {
                setState(() {
                  series.add({'kg': 0.0, 'reps': 0});
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Agregar Serie"),
            ),
          ],
        ),
      ),
    );
  }
}
