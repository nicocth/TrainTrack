// Tarjeta personalizada para cada ejercicio
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/sets.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';

class ExerciseCard extends ConsumerWidget {
  final int exerciseIndex;
  final CustomExercise customExercise;
  final TextEditingController notesController;
  final List<TextEditingController> repsControllers;
  final List<TextEditingController> weightControllers;
  final VoidCallback onDelete;

  const ExerciseCard(
      {super.key,
      required this.exerciseIndex,
      required this.customExercise,
      required this.notesController,
      required this.repsControllers,
      required this.weightControllers,
      required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección superior con imagen, nombre y menú de opciones
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            customExercise.exercise.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      customExercise.exercise.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    customExercise.exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDelete();
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Campo de notas
            SizedBox(
              height: 50,
              child: TextField(
                controller: notesController,
                onChanged: (value) {
                  notesController.text = value;
                },
                decoration: InputDecoration(
                  labelText: S.current.notes,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado de la tabla
                Row(
                  children: [
                    SizedBox(
                        width: 50,
                        child: Center(
                            child: Text(S.current.series,
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    SizedBox(width: 50),
                    SizedBox(
                        width: 50,
                        child: Center(
                            child: Text(S.current.kg,
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    SizedBox(width: 50),
                    SizedBox(
                        width: 50,
                        child: Center(
                            child: Text(S.current.reps,
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
                const SizedBox(height: 5),
                // Lista de series
                Column(
                  children: List.generate(customExercise.sets.length, (index) {
                    return Row(
                      children: [
                        SizedBox(
                            width: 50,
                            child: Center(
                                child:
                                    Text("${index + 1}"))), // Número de serie
                        const SizedBox(width: 50),
                        SizedBox(
                          // field for kg
                          width: 50,
                          child: TextField(
                            controller: weightControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: S.current.kg),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 50), // spacer
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: repsControllers[index],                          
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(hintText: S.current.reps),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 5), // spacer
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            trainingNotifier.removeSetFromExercise(
                                exerciseIndex, index);
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
                FocusScope.of(context).unfocus();
                trainingNotifier.addSetToExercise(
                    exerciseIndex, Sets(reps: 0, weight: 0));
              },
              icon: const Icon(Icons.add),
              label: Text(S.current.add_series),
            ),
          ],
        ),
      ),
    );
  }
}
