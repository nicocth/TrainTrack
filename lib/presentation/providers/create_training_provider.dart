import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Training {
  final TextEditingController titleController;
  final List<String> exercises;

  Training({required this.titleController, required this.exercises});
}

class TrainingNotifier extends StateNotifier<Training> {
  TrainingNotifier() : super(Training(titleController: TextEditingController(), exercises: []));

  void setTitle(String title) {
    state.titleController.text = title;
  }

  void addExercise(String exercise) {
    state = Training(
      titleController: state.titleController,
      exercises: [...state.exercises, exercise],
    );
  }

  void addExercises(List<String> newExercises) {
    state = Training(
      titleController: state.titleController,
      exercises: [...state.exercises, ...newExercises],
    );
  }

  void removeExercise(int index) {
    final updatedExercises = List<String>.from(state.exercises)..removeAt(index);
    state = Training(
      titleController: state.titleController,
      exercises: updatedExercises,
    );
  }
}

final trainingProvider = StateNotifierProvider<TrainingNotifier, Training>((ref) {
  return TrainingNotifier();
});
