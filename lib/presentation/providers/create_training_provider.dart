import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';

class CreateTrainingState {
  final TextEditingController titleController;
  final List<CustomExercise> customExercises;
  final List<TextEditingController> notesControllers;
  final List<List<TextEditingController>> repsControllers;
  final List<List<TextEditingController>> weightControllers;

  CreateTrainingState({
    required this.titleController,
    required this.customExercises,
    required this.notesControllers,
    required this.repsControllers,
    required this.weightControllers,
  });

  CreateTrainingState copyWith({
    TextEditingController? titleController,
    List<CustomExercise>? customExercises,
    List<TextEditingController>? notesControllers,
    List<List<TextEditingController>>? repsControllers,
    List<List<TextEditingController>>? weightControllers,
  }) {
    return CreateTrainingState(
      titleController: titleController ?? this.titleController,
      customExercises: customExercises ?? this.customExercises,
      notesControllers: notesControllers ?? this.notesControllers,
      repsControllers: repsControllers ?? this.repsControllers,
      weightControllers: weightControllers ?? this.weightControllers,
    );
  }
}

class TrainingNotifier extends StateNotifier<CreateTrainingState> {
  TrainingNotifier()
      : super(CreateTrainingState(
          titleController: TextEditingController(),
          customExercises: [],
          notesControllers: [],
          repsControllers: [],
          weightControllers: [],
        ));

  // Add an exercise with empty sets
  void addExercise(Exercise exercise) {
    final newCustomExercise =
        CustomExercise(exercise: exercise, order: 0, notes: "", sets: []);
    
    state.notesControllers.add(TextEditingController(text: ""));
    state.repsControllers.add([TextEditingController(text: "")]);
    state.weightControllers.add([TextEditingController(text: "")]);

    state = state.copyWith(
        customExercises: [...state.customExercises, newCustomExercise]);
  }

  // Add a list of exercises with empty sets
  void addExercises(List<Exercise> exercises) {
    final newCustomExercises = exercises
        .map((exercise) => CustomExercise(
              exercise: exercise,
              order: 0,
              notes: "",
              sets: [Sets(reps: 0, weight: 0)],
            ))
        .toList();

    final newNotesControllers = List.generate(
      exercises.length,
      (_) => TextEditingController(text: ""),
    );
    final newRepsControllers = List.generate(
      exercises.length,
      (_) => [TextEditingController(text: "")],
    );
    final newWeightControllers = List.generate(
      exercises.length,
      (_) => [TextEditingController(text: "")],
    );

    state.notesControllers.addAll(newNotesControllers);
    state.repsControllers.addAll(newRepsControllers);
    state.weightControllers.addAll(newWeightControllers);

    state = state.copyWith(
        customExercises: [...state.customExercises, ...newCustomExercises]);
  }

  // Remove an exercise from the list
  void removeExercise(int index) {
    // Release resources from drivers before deleting them
    state.notesControllers[index].dispose();
    for (var controller in state.repsControllers[index]) {
      controller.dispose();
    }
    for (var controller in state.weightControllers[index]) {
      controller.dispose();
    }

    // Create new lists without the element at the indicated index
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

  // Reorder exercises
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

  // Add a set to a specific exercise
  void addSetToExercise(int exerciseIndex, Sets sets) {
    final updatedExercises = [...state.customExercises];
    updatedExercises[exerciseIndex] = CustomExercise(
      notes: updatedExercises[exerciseIndex].notes,
      order: updatedExercises[exerciseIndex].order,
      exercise: updatedExercises[exerciseIndex].exercise,
      sets: [...updatedExercises[exerciseIndex].sets, sets],
    );
    state.repsControllers[exerciseIndex].add(TextEditingController(text: ""));
    state.weightControllers[exerciseIndex].add(TextEditingController(text: ""));
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Remove a set to a specific exercise
  void removeSetFromExercise(int exerciseIndex, int setIndex) {
    final updatedExercises = [...state.customExercises];
    final updatedSets = [...updatedExercises[exerciseIndex].sets]
      ..removeAt(setIndex);
    updatedExercises[exerciseIndex] = CustomExercise(
      exercise: updatedExercises[exerciseIndex].exercise,
      order: updatedExercises[exerciseIndex].order,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
    state.repsControllers[exerciseIndex].removeAt(setIndex);
    state.weightControllers[exerciseIndex].removeAt(setIndex);
    state = state.copyWith(customExercises: updatedExercises);
  }

  // Reset state
  void reset() {
    state = CreateTrainingState(
      titleController:
          TextEditingController(), 
      customExercises: [], 
      notesControllers: [],
      repsControllers: [],
      weightControllers: [],
    );
  }
}

final createTrainingProvider = StateNotifierProvider<TrainingNotifier, CreateTrainingState>(
  (ref) => TrainingNotifier(),
);
