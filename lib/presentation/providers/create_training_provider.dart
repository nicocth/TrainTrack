import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';

class TrainingState {
  final TextEditingController titleController;
  final List<CustomExercise> customExercises;
  final List<TextEditingController> notesControllers;
  final List<List<TextEditingController>> repsControllers;
  final List<List<TextEditingController>> weightControllers;

  TrainingState({
    required this.titleController,
    required this.customExercises,
    required this.notesControllers,
    required this.repsControllers,
    required this.weightControllers,
  });

  TrainingState copyWith({
    TextEditingController? titleController,
    List<CustomExercise>? customExercises,
    List<TextEditingController>? notesControllers,
    List<List<TextEditingController>>? repsControllers,
    List<List<TextEditingController>>? weightControllers,
  }) {
    return TrainingState(
      titleController: titleController ?? this.titleController,
      customExercises: customExercises ?? this.customExercises,
      notesControllers: notesControllers ?? this.notesControllers,
      repsControllers: repsControllers ?? this.repsControllers,
      weightControllers: weightControllers ?? this.weightControllers,
    );
  }
}

class TrainingNotifier extends StateNotifier<TrainingState> {
  TrainingNotifier()
      : super(TrainingState(
          titleController: TextEditingController(),
          customExercises: [],
          notesControllers: [],
          repsControllers: [],
          weightControllers: [],
        ));

  // Agregar un ejercicio como CustomExercise con sets vacíos
  void addExercise(Exercise exercise) {
    final newCustomExercise =
        CustomExercise(exercise: exercise, notes: "", sets: []);
    
    state.notesControllers.add(TextEditingController(text: ""));
    state.repsControllers.add([TextEditingController(text: "0")]);
    state.weightControllers.add([TextEditingController(text: "0.0")]);

    state = state.copyWith(
        customExercises: [...state.customExercises, newCustomExercise]);
  }

  // Agregar una lista de ejercicios como CustomExercise con un set vacío
  void addExercises(List<Exercise> exercises) {
    final newCustomExercises = exercises
        .map((exercise) => CustomExercise(
              exercise: exercise,
              notes: "",
              sets: [Sets(reps: 0, weight: 0)], // Un único set inicializado
            ))
        .toList();

    final newNotesControllers = List.generate(
      exercises.length,
      (_) => TextEditingController(text: ""),
    );
    final newRepsControllers = List.generate(
      exercises.length,
      (_) => [TextEditingController(text: "0")],
    );
    final newWeightControllers = List.generate(
      exercises.length,
      (_) => [TextEditingController(text: "0.0")],
    );

    state.notesControllers.addAll(newNotesControllers);
    state.repsControllers.addAll(newRepsControllers);
    state.weightControllers.addAll(newWeightControllers);

    state = state.copyWith(
        customExercises: [...state.customExercises, ...newCustomExercises]);
  }

  // Eliminar un ejercicio de la lista
  void removeExercise(int index) {
    final updatedExercises = [...state.customExercises]..removeAt(index);
    final updatedNotesControllers = [...state.notesControllers]..removeAt(index);
    final updatedRepsControllers = [...state.repsControllers]..removeAt(index);
    final updatedWeightControllers = [...state.weightControllers]..removeAt(index);

    state = state.copyWith(
      customExercises: updatedExercises,
      notesControllers: updatedNotesControllers,
      repsControllers: updatedRepsControllers,
      weightControllers: updatedWeightControllers,
    );
  }

  // Reordenar ejercicios
  void reorderExercise(int oldIndex, int newIndex) {
    final updatedExercises = [...state.customExercises];
    final updatedNotesControllers = [...state.notesControllers];
    final updatedRepsControllers = [...state.repsControllers];
    final updatedWeightControllers = [...state.weightControllers];

    if (newIndex > oldIndex) newIndex--;

    final exercise = updatedExercises.removeAt(oldIndex);
    final noteController = updatedNotesControllers.removeAt(oldIndex);
    final repsController = updatedRepsControllers.removeAt(oldIndex);
    final weightController = updatedWeightControllers.removeAt(oldIndex);

    updatedExercises.insert(newIndex, exercise);
    updatedNotesControllers.insert(newIndex, noteController);
    updatedRepsControllers.insert(newIndex, repsController);
    updatedWeightControllers.insert(newIndex, weightController);

    state = state.copyWith(
      customExercises: updatedExercises,
      notesControllers: updatedNotesControllers,
      repsControllers: updatedRepsControllers,
      weightControllers: updatedWeightControllers,
    );
  }

  // Actualizar el título
  void setTitle(String title) {
    state.titleController.text = title;
  }

  // Agregar una serie a un ejercicio específico
  void addSetToExercise(int exerciseIndex, Sets sets) {
    final updatedExercises = [...state.customExercises];
    updatedExercises[exerciseIndex] = CustomExercise(
      notes: updatedExercises[exerciseIndex].notes,
      exercise: updatedExercises[exerciseIndex].exercise,
      sets: [...updatedExercises[exerciseIndex].sets, sets],
    );
    state.repsControllers[exerciseIndex].add(TextEditingController(text: "0"));
    state.weightControllers[exerciseIndex].add(TextEditingController(text: "0.0"));
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Eliminar una serie de un ejercicio específico
  void removeSetFromExercise(int exerciseIndex, int setIndex) {
    final updatedExercises = [...state.customExercises];
    final updatedSets = [...updatedExercises[exerciseIndex].sets]
      ..removeAt(setIndex);
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
    state.repsControllers[exerciseIndex].removeAt(setIndex);
    state.weightControllers[exerciseIndex].removeAt(setIndex);
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Actualizar notas de un ejercicio específico
  void updateExerciseNotes(int exerciseIndex, String notes) {
    final updatedExercises = [...state.customExercises];
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      notes: notes,
      sets: updatedExercises[exerciseIndex].sets,
    );
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Actualizar reps de un set específico
  void updateSetReps(int exerciseIndex, int setIndex, int reps) {
    final updatedExercises = [...state.customExercises];
    final updatedSets = [...updatedExercises[exerciseIndex].sets];
    updatedSets[setIndex] =
        Sets(reps: reps, weight: updatedSets[setIndex].weight);
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Actualizar weight de un set específico
  void updateSetWeight(int exerciseIndex, int setIndex, double weight) {
    final updatedExercises = [...state.customExercises];
    final updatedSets = [...updatedExercises[exerciseIndex].sets];
    updatedSets[setIndex] =
        Sets(reps: updatedSets[setIndex].reps, weight: weight);
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
    state = state.copyWith(customExercises: updatedExercises);
  }

  void updateTrainingProperties({
    String? title,
    List<CustomExercise>? customExercises,
  }) {
    state = state.copyWith(
      titleController: title != null
          ? TextEditingController(text: title)
          : state.titleController,
      customExercises: customExercises ?? state.customExercises,
    );
  }

  // Método para resetear el estado
  void reset() {
    state = TrainingState(
      titleController:
          TextEditingController(), // reinicia el controlador del título
      customExercises: [], // reinicia la lista de ejercicios
      notesControllers: [],
      repsControllers: [],
      weightControllers: [],
    );
  }
}

final trainingProvider = StateNotifierProvider<TrainingNotifier, TrainingState>(
  (ref) => TrainingNotifier(),
);
