import 'package:flutter_riverpod/flutter_riverpod.dart';

class Training {
  String title;
  List<String> exercises;

  Training({required this.title, required this.exercises});
}

class TrainingNotifier extends StateNotifier<Training> {
  TrainingNotifier() : super(Training(title: '', exercises: []));

  void setTitle(String title) {
    state = Training(title: title, exercises: state.exercises);
  }

  void addExercise(String exercise) {
    state = Training(title: state.title, exercises: [...state.exercises, exercise]);
  }

  void removeExercise(int index) {
    final updatedExercises = List<String>.from(state.exercises)..removeAt(index);
    state = Training(title: state.title, exercises: updatedExercises);
  }
}

final trainingProvider = StateNotifierProvider<TrainingNotifier, Training>((ref) {
  return TrainingNotifier();
});
