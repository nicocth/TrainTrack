import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/sets.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_edit.dart';
import 'add_exercise_screen.dart';

class CreateTrainingScreen extends ConsumerStatefulWidget {
  const CreateTrainingScreen({super.key});

  @override
  ConsumerState<CreateTrainingScreen> createState() =>
      _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends ConsumerState<CreateTrainingScreen> {
  final TextEditingController titleController = TextEditingController();
  final List<CustomExercise> customExercises = [];
  final List<TextEditingController> notesControllers = [];
  final List<List<TextEditingController>> repsControllers = [];
  final List<List<TextEditingController>> weightControllers = [];

  @override
  void dispose() {
    for (var controller in notesControllers) {
      controller.dispose();
    }
    for (var repsList in repsControllers) {
      for (var controller in repsList) {
        controller.dispose();
      }
    }
    for (var weightList in weightControllers) {
      for (var controller in weightList) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final newTraining = ref.read(trainingProvider);

    // Inicializar los controladores para cada ejercicio existente
    for (var exercise in newTraining.customExercises) {
      _addLocalExercise(exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateValuesFromProvider();

    final trainingNotifier = ref.read(trainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.create_routine),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTraining,
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

            // Lista de ejercicios en tarjetas personalizadas con botón de agregar al final
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final exercise = customExercises.removeAt(oldIndex);
                    final noteController = notesControllers.removeAt(oldIndex);
                    final reps = repsControllers.removeAt(oldIndex);
                    final weights = weightControllers.removeAt(oldIndex);

                    customExercises.insert(newIndex, exercise);
                    notesControllers.insert(newIndex, noteController);
                    repsControllers.insert(newIndex, reps);
                    weightControllers.insert(newIndex, weights);
                  });
                },
                children: [
                  for (int index = 0; index < customExercises.length; index++)
                    ExerciseCard(
                      key: ValueKey(customExercises[index]),
                      exerciseIndex: index,
                      customExercise: customExercises[index],
                      notesController: notesControllers[index],
                      repsControllers: repsControllers[index],
                      weightControllers: weightControllers[index],
                      onDelete: () {
                        setState(() {
                          customExercises.removeAt(index);
                          notesControllers[index].dispose();
                          notesControllers.removeAt(index);
                          repsControllers[index].forEach((c) => c.dispose());
                          repsControllers.removeAt(index);
                          weightControllers[index].forEach((c) => c.dispose());
                          weightControllers.removeAt(index);
                        });
                      },
                    ),
                ],
              ),
            ),
            // Botón para agregar ejercicio
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(S.current.add_exercise),
              onPressed: () {
                _saveDataInProvider();
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

  void _addLocalExercise(CustomExercise exercise) {
    setState(() {
      customExercises.add(exercise);
      notesControllers.add(TextEditingController(text: exercise.notes));
      repsControllers.add(exercise.sets
          .map((set) => TextEditingController(text: set.reps.toString()))
          .toList());
      weightControllers.add(exercise.sets
          .map((set) => TextEditingController(text: set.weight.toString()))
          .toList());
    });
  }

  void _updateValuesFromProvider() {
    final newTraining = ref.watch(trainingProvider);

    // Limpia las listas para evitar duplicados
    customExercises.clear();
    notesControllers.clear();
    repsControllers.clear();
    weightControllers.clear();

    // Inicializa los controladores solo si hay ejercicios
    for (var exercise in newTraining.customExercises) {
      _addLocalExercise(exercise);
    }
  }

  void _clearDataAndRefresh() {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    // Limpiar controladores
    titleController.clear();
    for (var controller in notesControllers) {
      controller.dispose();
    }
    for (var repsList in repsControllers) {
      for (var controller in repsList) {
        controller.dispose();
      }
    }
    for (var weightList in weightControllers) {
      for (var controller in weightList) {
        controller.dispose();
      }
    }

    // Limpiar listas
    setState(() {
      customExercises.clear();
      notesControllers.clear();
      repsControllers.clear();
      weightControllers.clear();
    });

    // Llamar al reset del provider
    trainingNotifier.reset();  
  }

  void _saveDataInProvider() {
    final trainingNotifier = ref.read(trainingProvider.notifier);
    customExercises;
    notesControllers;
    weightControllers;
    titleController;
    repsControllers;

    final updatedCustomExercises =
        List<CustomExercise>.generate(customExercises.length, (i) {
      return CustomExercise(
        exercise: customExercises[i].exercise,
        notes: notesControllers[i].text,
        sets: List.generate(customExercises[i].sets.length, (j) {
          return Sets(
            weight: double.tryParse(weightControllers[i][j].text) ??
                0.0, // Actualizar peso
            reps: int.tryParse(repsControllers[i][j].text) ??
                0, // Actualizar reps
          );
        }),
      );
    });

    // Actualizar el estado en el provider
    trainingNotifier.updateTrainingProperties(
      title: titleController.text,
      customExercises: updatedCustomExercises,
    );
  }

  Future<void> _saveTraining() async {
    final authNotifier = ref.read(authProvider.notifier);
    final userId = authNotifier.getUserId();

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_title)),
      );
      return;
    }

    if (customExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_exercises_list)),
      );
      return;
    }

    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final routinesRef = userRef.collection('trainings');

      final routineDoc = await routinesRef.add({
        'title': titleController.text,
        'date_created': Timestamp.now(),
        'date_updated': Timestamp.now(),
      });

      for (int i = 0; i < customExercises.length; i++) {
        await routineDoc.collection('exercises').add({
          'exercise': customExercises[i].exercise.id,
          'name': customExercises[i].exercise.name,
          'notes': notesControllers[i].text,
          'sets': List.generate(customExercises[i].sets.length, (j) {
            return {
              'weight': double.tryParse(weightControllers[i][j].text) ?? 0.0,
              'reps': int.tryParse(repsControllers[i][j].text) ?? 0,
            };
          }),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.routine_saved)),
      );

      _clearDataAndRefresh();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.error_saving_routine)),
      );
    }
  }
}
