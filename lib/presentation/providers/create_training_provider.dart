import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';

class TrainingState {
  final TextEditingController titleController;
  final List<CustomExercise> customExercises;

  TrainingState({
    required this.titleController,
    required this.customExercises,
  });

  TrainingState copyWith({
    TextEditingController? titleController,
    List<CustomExercise>? customExercises,
  }) {
    return TrainingState(
      titleController: titleController ?? this.titleController,
      customExercises: customExercises ?? this.customExercises,
    );
  }
}

class TrainingNotifier extends StateNotifier<TrainingState> {
  TrainingNotifier()
      : super(TrainingState(
          titleController: TextEditingController(),
          customExercises: [],
        ));

  // Agregar un ejercicio como CustomExercise con sets vacíos
  void addExercise(Exercise exercise) {
    final newCustomExercise = CustomExercise(exercise: exercise,notes: "", sets: []);
    state = state.copyWith(customExercises: [...state.customExercises, newCustomExercise]);
  }

  // Agregar una lista de ejercicios como CustomExercise con un set vacío
  void addExercises(List<Exercise> exercises) {
    final newCustomExercises = exercises.map((exercise) => 
      CustomExercise(
        exercise: exercise,
        notes: "",
        sets: [Sets(reps: 0, weight: 0)], // Un único set inicializado
      )
    ).toList();

    state = state.copyWith(customExercises: [...state.customExercises, ...newCustomExercises]);
  }

  // Eliminar un ejercicio de la lista
  void removeExercise(int index) {
    final updatedExercises = [...state.customExercises]..removeAt(index);
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Reordenar ejercicios
  void reorderExercise(int oldIndex, int newIndex) {
    final updatedExercises = [...state.customExercises];
    if (newIndex > oldIndex) newIndex--;
    final item = updatedExercises.removeAt(oldIndex);
    updatedExercises.insert(newIndex, item);
    state = state.copyWith(customExercises: updatedExercises);
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
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Eliminar una serie de un ejercicio específico
  void removeSetFromExercise(int exerciseIndex, int setIndex) {
    final updatedExercises = [...state.customExercises];
    final updatedSets = [...updatedExercises[exerciseIndex].sets]..removeAt(setIndex);
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
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
    updatedSets[setIndex] = Sets(reps: reps, weight: updatedSets[setIndex].weight);
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
    updatedSets[setIndex] = Sets(reps: updatedSets[setIndex].reps, weight: weight);
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
    state = state.copyWith(customExercises: updatedExercises);
  }
}

final trainingProvider = StateNotifierProvider<TrainingNotifier, TrainingState>(
  (ref) => TrainingNotifier(),
);
