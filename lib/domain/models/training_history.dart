import 'package:train_track/domain/models/custom_exercise.dart';

class TrainingHistory {
  final String id;
  final String name;
  final DateTime trainingDate;
  final List<CustomExercise> exercises;

  TrainingHistory({
    required this.id,
    required this.name,
    required this.exercises,
    DateTime? trainingDate,
  })  : trainingDate = trainingDate ?? DateTime.now();

  TrainingHistory copyWith({
    String? id,
    String? name,
    DateTime? trainingDate,
    List<CustomExercise>? exercises,
  }) {
    return TrainingHistory(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      trainingDate: trainingDate ?? this.trainingDate
    );
  }
}