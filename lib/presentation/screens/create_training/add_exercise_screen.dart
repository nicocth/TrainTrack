import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';

class AddExerciseScreen extends ConsumerWidget {
  const AddExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    final List<String> availableExercises = [
      "Sentadilla",
      "Press de banca",
      "Peso muerto",
      "Dominadas",
      "Remo con barra"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Ejercicio")),
      body: ListView.builder(
        itemCount: availableExercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(availableExercises[index]),
            trailing: IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () {
                trainingNotifier.addExercise(availableExercises[index]);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
