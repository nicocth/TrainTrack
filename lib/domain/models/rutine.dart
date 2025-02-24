import 'package:train_track/domain/models/custom_exercise.dart';

class Rutine {
  final String id;
  final String name;
  final DateTime dateCreated;
  final DateTime dateUpdated;
  final List<CustomExercise> exercises;

  Rutine({
    required this.id,
    required this.name,
    required this.exercises,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        dateUpdated = dateUpdated ?? DateTime.now();

}