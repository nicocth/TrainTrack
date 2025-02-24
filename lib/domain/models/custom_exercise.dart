import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';

class CustomExercise{
  final Exercise exercise;
  final List<Sets> sets;

  CustomExercise({
    required this.exercise,
    required this.sets,
  });
}