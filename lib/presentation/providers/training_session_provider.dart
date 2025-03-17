import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/domain/models/custom_exercise.dart';

class TrainingSessionState {
  final Training? training;
  final int seconds;
  final bool isRunning;
  final int? selectedExerciseIndex;
  final Set<int> completedExercises;
  final List<TextEditingController> notesControllers;
  final List<List<TextEditingController>> repsControllers;
  final List<List<TextEditingController>> weightControllers;

  TrainingSessionState({
    required this.training,
    required this.seconds,
    required this.isRunning,
    required this.selectedExerciseIndex,
    required this.completedExercises,
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
    List<TextEditingController>? notesControllers,
    List<List<TextEditingController>>? repsControllers,
    List<List<TextEditingController>>? weightControllers,
  }) {
    return TrainingSessionState(
      training: training ?? this.training,
      seconds: seconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
      selectedExerciseIndex: selectedExerciseIndex ?? this.selectedExerciseIndex,
      completedExercises: completedExercises ?? this.completedExercises,
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
    state = state.copyWith(training: training, seconds: 0, isRunning: true);
    startTimer();
  }

  void _initControllers(List<CustomExercise> sortedExercises) {
    final notesControllers = sortedExercises.map((e) => TextEditingController(text: e.notes)).toList();
    final repsControllers = sortedExercises
        .map((e) => e.sets.map((s) => TextEditingController(text: s.reps.toString())).toList())
        .toList();
    final weightControllers = sortedExercises
        .map((e) => e.sets.map((s) => TextEditingController(text: s.weight.toString())).toList())
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

  void resetSession() {
    _timer?.cancel();
    _elapsedTime = 0;
    state = state.copyWith(
      training: null,
      seconds: 0,
      isRunning: false,
      selectedExerciseIndex: null,
      completedExercises: {},
      notesControllers: [],
      repsControllers: [],
      weightControllers: [],
    );
  }

  void selectExercise(int index) {
    state = state.copyWith(selectedExerciseIndex: index);
  }

  void markExerciseCompleted(int index) {
    final updatedCompletedExercises = Set<int>.from(state.completedExercises)..add(index);
    state = state.copyWith(completedExercises: updatedCompletedExercises);
  }
}

final trainingSessionProvider = StateNotifierProvider<TrainingSessionNotifier, TrainingSessionState>((ref) => TrainingSessionNotifier());
