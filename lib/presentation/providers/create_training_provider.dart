import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';
import 'package:train_track/domain/models/training.dart';

class CreateTrainingState {
  final TextEditingController titleController;
  final List<CustomExercise> customExercises;
  final List<TextEditingController> alternativeControllers;
  final List<TextEditingController> notesControllers;
  final List<List<TextEditingController>> repsControllers;
  final List<List<TextEditingController>> weightControllers;

  CreateTrainingState({
    required this.titleController,
    required this.customExercises,
    required this.alternativeControllers,
    required this.notesControllers,
    required this.repsControllers,
    required this.weightControllers,
  });

  CreateTrainingState copyWith({
    TextEditingController? titleController,
    List<CustomExercise>? customExercises,
    List<TextEditingController>? alternativeControllers,
    List<TextEditingController>? notesControllers,
    List<List<TextEditingController>>? repsControllers,
    List<List<TextEditingController>>? weightControllers,
  }) {
    return CreateTrainingState(
      titleController: titleController ?? this.titleController,
      customExercises: customExercises ?? this.customExercises,
      alternativeControllers:
          alternativeControllers ?? this.alternativeControllers,
      notesControllers: notesControllers ?? this.notesControllers,
      repsControllers: repsControllers ?? this.repsControllers,
      weightControllers: weightControllers ?? this.weightControllers,
    );
  }
}

class CreateTrainingNotifier extends StateNotifier<CreateTrainingState> {
  CreateTrainingNotifier()
      : super(CreateTrainingState(
          titleController: TextEditingController(),
          customExercises: [],
          alternativeControllers: [],
          notesControllers: [],
          repsControllers: [],
          weightControllers: [],
        ));

// Load existing training into state
  void loadTraining(Training training) {
    //list is reordered since firebase returns it unordered and the provider does not have order property
    final sortedExercises = List<CustomExercise>.from(training.exercises)
      ..sort((a, b) => a.order.compareTo(b.order));

    final titleController = TextEditingController(text: training.name);

    final alternativeControllers = sortedExercises.map((exercise) {
      return exercise.isAlternative
          ? TextEditingController(text: exercise.alternative?.toString() ?? "")
          : TextEditingController(); // If not alternative, an empty controller is added
    }).toList();

    final notesControllers = sortedExercises
        .map((exercise) => TextEditingController(text: exercise.notes))
        .toList();

    final repsControllers = sortedExercises
        .map((exercise) => exercise.sets
            .map((set) => TextEditingController(text: set.reps.toString()))
            .toList())
        .toList();

    final weightControllers = sortedExercises
        .map((exercise) => exercise.sets
            .map((set) => TextEditingController(text: set.weight.toString()))
            .toList())
        .toList();

    state = CreateTrainingState(
      titleController: titleController,
      customExercises: sortedExercises,
      alternativeControllers: alternativeControllers,
      notesControllers: notesControllers,
      repsControllers: repsControllers,
      weightControllers: weightControllers,
    );
  }

  // Add an exercise with empty sets
  void addExercise(Exercise exercise) {
    final newCustomExercise = CustomExercise(
        exercise: exercise,
        isAlternative: false,
        order: 0,
        notes: "",
        sets: []);

    state.alternativeControllers.add(TextEditingController(text: ""));
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
              isAlternative: false,
              order: 0,
              notes: "",
              sets: [Sets(reps: 0, weight: 0)],
            ))
        .toList();

    final newAlternativeControllers = List.generate(
      exercises.length,
      (_) => TextEditingController(text: ""),
    );
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

    state.alternativeControllers.addAll(newAlternativeControllers);
    state.notesControllers.addAll(newNotesControllers);
    state.repsControllers.addAll(newRepsControllers);
    state.weightControllers.addAll(newWeightControllers);

    state = state.copyWith(
        customExercises: [...state.customExercises, ...newCustomExercises]);
  }

  // Remove an exercise from the list
  void removeExercise(int index) {
    // Release resources from drivers before deleting them
    state.alternativeControllers[index].dispose();
    state.notesControllers[index].dispose();
    for (var controller in state.repsControllers[index]) {
      controller.dispose();
    }
    for (var controller in state.weightControllers[index]) {
      controller.dispose();
    }

    // Create new lists without the element at the indicated index
    final updatedExercises = [...state.customExercises]..removeAt(index);
    final updatedAlternativeControllers = [...state.alternativeControllers]
      ..removeAt(index);
    final updatedNotesControllers = [...state.notesControllers]
      ..removeAt(index);
    final updatedRepsControllers = [...state.repsControllers]..removeAt(index);
    final updatedWeightControllers = [...state.weightControllers]
      ..removeAt(index);

    state = state.copyWith(
      customExercises: updatedExercises,
      alternativeControllers: updatedAlternativeControllers,
      notesControllers: updatedNotesControllers,
      repsControllers: updatedRepsControllers,
      weightControllers: updatedWeightControllers,
    );
  }

  // Reorder exercises
  void reorderExercise(int oldIndex, int newIndex) {
    final updatedExercises = [...state.customExercises];
    final updatedAlternativeControllers = [...state.alternativeControllers];
    final updatedNotesControllers = [...state.notesControllers];
    final updatedRepsControllers = [...state.repsControllers];
    final updatedWeightControllers = [...state.weightControllers];

    if (newIndex > oldIndex) newIndex--;

    final exercise = updatedExercises.removeAt(oldIndex);
    final alternativeController =
        updatedAlternativeControllers.removeAt(oldIndex);
    final noteController = updatedNotesControllers.removeAt(oldIndex);
    final repsController = updatedRepsControllers.removeAt(oldIndex);
    final weightController = updatedWeightControllers.removeAt(oldIndex);

    updatedExercises.insert(newIndex, exercise);
    updatedAlternativeControllers.insert(newIndex, alternativeController);
    updatedNotesControllers.insert(newIndex, noteController);
    updatedRepsControllers.insert(newIndex, repsController);
    updatedWeightControllers.insert(newIndex, weightController);

    state = state.copyWith(
      customExercises: updatedExercises,
      alternativeControllers: updatedAlternativeControllers,
      notesControllers: updatedNotesControllers,
      repsControllers: updatedRepsControllers,
      weightControllers: updatedWeightControllers,
    );
  }

  // Add a set to a specific exercise
  void addSetToExercise(int exerciseIndex, Sets sets) {
    final updatedExercises = [...state.customExercises];
    updatedExercises[exerciseIndex] = CustomExercise(
      isAlternative: updatedExercises[exerciseIndex].isAlternative,
      alternative: updatedExercises[exerciseIndex].alternative,
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
      isAlternative: updatedExercises[exerciseIndex].isAlternative,
      exercise: updatedExercises[exerciseIndex].exercise,
      order: updatedExercises[exerciseIndex].order,
      alternative: updatedExercises[exerciseIndex].alternative,
      notes: updatedExercises[exerciseIndex].notes,
      sets: updatedSets,
    );
    state.repsControllers[exerciseIndex].removeAt(setIndex);
    state.weightControllers[exerciseIndex].removeAt(setIndex);
    state = state.copyWith(customExercises: updatedExercises);
  }

  // toggle isAlternative
  void toggleAlternative(int index) {
    final updatedExercises = [...state.customExercises];

    updatedExercises[index] = CustomExercise(
      exercise: updatedExercises[index].exercise,
      order: updatedExercises[index].order,
      notes: updatedExercises[index].notes,
      sets: updatedExercises[index].sets,
      isAlternative: !updatedExercises[index].isAlternative,
      alternative: updatedExercises[index].isAlternative
          ? null
          : updatedExercises[index].alternative,
    );

    state = state.copyWith(customExercises: updatedExercises);
  }

  // Reset state
  void reset() {
    state = CreateTrainingState(
      titleController: TextEditingController(),
      customExercises: [],
      alternativeControllers: [],
      notesControllers: [],
      repsControllers: [],
      weightControllers: [],
    );
  }
}

final createTrainingProvider =
    StateNotifierProvider<CreateTrainingNotifier, CreateTrainingState>(
  (ref) => CreateTrainingNotifier(),
);
