import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final List<String> availableExercises = [
    "Sentadilla",
    "Press de banca",
    "Peso muerto",
    "Dominadas",
    "Remo con barra"
  ];

  final Set<String> selectedExercises = {};

  @override
  Widget build(BuildContext context) {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Ejercicios")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: availableExercises.length,
              itemBuilder: (context, index) {
                final exercise = availableExercises[index];
                final isSelected = selectedExercises.contains(exercise);

                return ListTile(
                  title: Text(exercise),
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.green : null,
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedExercises.remove(exercise);
                      } else {
                        selectedExercises.add(exercise);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Botón para agregar ejercicios seleccionados
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedExercises.isEmpty
                  ? null
                  : () {
                      trainingNotifier.addExercises(selectedExercises.toList());
                      Navigator.pop(context);
                    },
              child: const Text("Agregar Seleccionados"),
            ),
          ),
        ],
      ),
    );
  }
}
