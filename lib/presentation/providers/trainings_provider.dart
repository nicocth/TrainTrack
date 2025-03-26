import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';

class TrainingsState {
  final List<Training> trainings;
  final bool isLoading;
  final String? errorMessage;

  TrainingsState({
    required this.trainings,
    required this.isLoading,
    this.errorMessage,
  });

  TrainingsState copyWith({
    List<Training>? trainings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TrainingsState(
      trainings: trainings ?? this.trainings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TrainingsNotifier extends StateNotifier<TrainingsState> {
  final FirestoreService _firestoreService = FirestoreService();

  TrainingsNotifier() 
  : super(TrainingsState(
    trainings: [], 
    isLoading: true
    ));

  Future<void> loadTrainings(WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    final userId = authNotifier.getUserId();
    try {
      final trainings = await _firestoreService.getAllTrainings(userId);

      state = state.copyWith(trainings: trainings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Error loading trainings: $e', isLoading: false);
    }
  }

  Future<void> deleteTraining(WidgetRef ref, String trainingId) async {
    final authNotifier = ref.read(authProvider.notifier);
    final userId = authNotifier.getUserId();
    try {
      await _firestoreService.deleteTraining(userId, trainingId);

      // We filter the list without the deleted element
      final updatedTrainings =
          state.trainings.where((t) => t.id != trainingId).toList();
      state = state.copyWith(trainings: updatedTrainings);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error deleting training: $e');
    }
  }
}

final trainingsProvider =
    StateNotifierProvider<TrainingsNotifier, TrainingsState>(
  (ref) => TrainingsNotifier(),
);
