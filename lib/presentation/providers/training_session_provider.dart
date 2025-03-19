import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:train_track/domain/models/sets.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/domain/models/custom_exercise.dart';

class TrainingSessionState {
  final int seconds;
  final bool isRunning;
  // training is received in a disordered manner from firebase to work with it you will always have to sort it first by order
  final Training? training;
  // It will refer to the order, not to the index of the unordered list, it will match directly with the controllers
  final int? selectedExerciseIndex;
  // Set of exercises that have been completed
  final Set<int> completedExercises;
  final List<Set<int>> completedSets;
  // Controllers are created ordered by the order property and this order is maintained when sets are added or removed.
  final List<TextEditingController> notesControllers;
  final List<List<TextEditingController>> repsControllers;
  final List<List<TextEditingController>> weightControllers;

  TrainingSessionState({
    required this.training,
    required this.seconds,
    required this.isRunning,
    required this.selectedExerciseIndex,
    required this.completedExercises,
    required this.completedSets,
    required this.notesControllers,
    required this.repsControllers,
    required this.weightControllers,
  });

  TrainingSessionState copyWith({
    Training? training,
    int? seconds,
    bool? isRunning,
    int? selectedExerciseIndex,
    Set<int>? completedExercises,
    List<Set<int>>? completedSets,
    List<TextEditingController>? notesControllers,
    List<List<TextEditingController>>? repsControllers,
    List<List<TextEditingController>>? weightControllers,
  }) {
    return TrainingSessionState(
      training: training ?? this.training,
      seconds: seconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
      selectedExerciseIndex:
          selectedExerciseIndex ?? this.selectedExerciseIndex,
      completedExercises: completedExercises ?? this.completedExercises,
      completedSets: completedSets ?? this.completedSets,
      notesControllers: notesControllers ?? this.notesControllers,
      repsControllers: repsControllers ?? this.repsControllers,
      weightControllers: weightControllers ?? this.weightControllers,
    );
  }
}

class TrainingSessionNotifier extends StateNotifier<TrainingSessionState> {
  Timer? _timer;
  int _elapsedTime = 0;

  TrainingSessionNotifier()
      : super(TrainingSessionState(
          training: null,
          seconds: 0,
          isRunning: false,
          selectedExerciseIndex: null,
          completedExercises: {},
          completedSets: [],
          notesControllers: [],
          repsControllers: [],
          weightControllers: [],
        ));

  void startSession(Training training) {
    _elapsedTime = 0;

    // Sort the exercises by the 'order' property before starting the session
    final sortedExercises = List<CustomExercise>.from(training.exercises)
      ..sort((a, b) => a.order.compareTo(b.order));

    // Start the drivers with the sorted exercises
    _initControllers(sortedExercises);

    // Set training and session status
    state = state.copyWith(
      training: training,
      seconds: 0,
      isRunning: true,
      completedSets: List.generate(sortedExercises.length, (_) => {}),
    );
    startTimer();
  }

  void _initControllers(List<CustomExercise> sortedExercises) {
    final notesControllers = sortedExercises
        .map((e) => TextEditingController(text: e.notes))
        .toList();
    final repsControllers = sortedExercises
        .map((e) => e.sets
            .map((s) => TextEditingController(text: s.reps.toString()))
            .toList())
        .toList();
    final weightControllers = sortedExercises
        .map((e) => e.sets
            .map((s) => TextEditingController(text: s.weight.toString()))
            .toList())
        .toList();

    state = state.copyWith(
      notesControllers: notesControllers,
      repsControllers: repsControllers,
      weightControllers: weightControllers,
    );
  }

  void startTimer() {
    _timer?.cancel(); // Cancel the previous timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime++;
      state = state.copyWith(seconds: _elapsedTime);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void selectExercise(int index) {
    state = state.copyWith(selectedExerciseIndex: index);
  }

  void markExerciseCompleted(int exerciseOrder) {
    final updatedCompletedExercises = Set<int>.from(state.completedExercises)
      ..add(exerciseOrder);
    state = state.copyWith(completedExercises: updatedCompletedExercises);
  }

  void markSetAsCompleted(int exerciseOrder, int setIndex) {

    final updatedCompletedSets = List<Set<int>>.from(state.completedSets);
    updatedCompletedSets[exerciseOrder] = Set<int>.from(updatedCompletedSets[exerciseOrder])..add(setIndex);

    state = state.copyWith(completedSets: updatedCompletedSets);
  }

  void markSetAsNotCompleted(int exerciseOrder, int setIndex) {

    final updatedCompletedSets = List<Set<int>>.from(state.completedSets);
    updatedCompletedSets[exerciseOrder] = Set<int>.from(updatedCompletedSets[exerciseOrder])..remove(setIndex);

    state = state.copyWith(completedSets: updatedCompletedSets);
  }
  
  void addSetToExercise(int exerciseOrder) {
    final training = state.training;
    if (training == null) return;

    final exerciseIndex =
        training.exercises.indexWhere((e) => e.order == exerciseOrder);
    if (exerciseIndex == -1) return;

    // Add a new set to the exercise
    final updatedExercise = training.exercises[exerciseIndex].copyWith(
      sets: [
        ...training.exercises[exerciseIndex].sets,
        Sets(reps: 0, weight: 0)
      ],
    );

    // Update the exercise list
    final updatedExercises = List<CustomExercise>.from(training.exercises)
      ..[exerciseIndex] = updatedExercise;

    // Add new controllers for the new set
    final newRepsController = TextEditingController(text: '');
    final newWeightController = TextEditingController(text: '');

    final updatedRepsControllers =
        List<List<TextEditingController>>.from(state.repsControllers)
          ..[exerciseOrder].add(newRepsController);

    final updatedWeightControllers =
        List<List<TextEditingController>>.from(state.weightControllers)
          ..[exerciseOrder].add(newWeightController);

    // Update status
    state = state.copyWith(
      training: training.copyWith(exercises: updatedExercises),
      repsControllers: updatedRepsControllers,
      weightControllers: updatedWeightControllers,
    );
  }

  void removeSetFromExercise(int exerciseOrder, int setIndex) {
    final training = state.training;
    if (training == null) return;

    final exerciseIndex =
        training.exercises.indexWhere((e) => e.order == exerciseOrder);
    if (exerciseIndex == -1) return;

    // Remove the set from the exercise
    final updatedExercise = training.exercises[exerciseIndex].copyWith(
      sets: List<Sets>.from(training.exercises[exerciseIndex].sets)
        ..removeAt(setIndex),
    );

    // Update the exercise list
    final updatedExercises = List<CustomExercise>.from(training.exercises)
      ..[exerciseIndex] = updatedExercise;

    // Removes the controllers associated with the deleted set
    final updatedRepsControllers =
        List<List<TextEditingController>>.from(state.repsControllers)
          ..[exerciseOrder].removeAt(setIndex);

    final updatedWeightControllers =
        List<List<TextEditingController>>.from(state.weightControllers)
          ..[exerciseOrder].removeAt(setIndex);

    // if the set was completed, remove it from the completed sets
    markSetAsNotCompleted(exerciseOrder, setIndex);

    // Update status
    state = state.copyWith(
      training: training.copyWith(exercises: updatedExercises),
      repsControllers: updatedRepsControllers,
      weightControllers: updatedWeightControllers,
    );
  }

  void resetSession() {
    _timer?.cancel();
    _elapsedTime = 0;
    state = state.copyWith(
      training: null,
      seconds: 0,
      isRunning: false,
      selectedExerciseIndex: null,
      completedExercises: {},
      completedSets: [],
      notesControllers: [],
      repsControllers: [],
      weightControllers: [],
    );
  }
}

final trainingSessionProvider =
    StateNotifierProvider<TrainingSessionNotifier, TrainingSessionState>(
        (ref) => TrainingSessionNotifier());
