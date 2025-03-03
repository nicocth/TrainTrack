import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';

class CustomExercise {
  final Exercise exercise;
  final String notes;
  final int order;
  final List<Sets> sets;

  CustomExercise({
    required this.exercise,
    required this.notes,
    required this.order,
    required this.sets,
  });
}
