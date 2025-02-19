import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/ejercicio.dart';

class Training {
  final TextEditingController titleController;
  final List<Ejercicio> exercises;

  Training({required this.titleController, required this.exercises});
}

class TrainingNotifier extends StateNotifier<Training> {
  TrainingNotifier() : super(Training(titleController: TextEditingController(), exercises: []));

  void setTitle(String title) {
    state.titleController.text = title;
  }

  void addExercise(Ejercicio exercise) {
    state = Training(
      titleController: state.titleController,
      exercises: [...state.exercises, exercise],
    );
  }

  void addExercises(List<Ejercicio> newExercises) {
    state = Training(
      titleController: state.titleController,
      exercises: [...state.exercises, ...newExercises],
    );
  }

  void removeExercise(int index) {
    final updatedExercises = List<Ejercicio>.from(state.exercises)..removeAt(index);
    state = Training(
      titleController: state.titleController,
      exercises: updatedExercises,
    );
  }
}

final trainingProvider = StateNotifierProvider<TrainingNotifier, Training>((ref) {
  return TrainingNotifier();
});
