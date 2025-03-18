import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/sets.dart';

class CustomExercise {
  final String id;
  final Exercise exercise;
  final String notes;
  final int order;
  final bool isAlternative;
  final int? alternative;
  final List<Sets> sets;

  CustomExercise({
    required this.id,
    required this.exercise,
    required this.notes,
    required this.order,
    required this.sets,
    required this.isAlternative,
    this.alternative
  });

  CustomExercise copyWith({
    String? id,
    Exercise? exercise,
    String? notes,
    int? order,
    bool? isAlternative,
    int? alternative,
    List<Sets>? sets,
  }) {
    return CustomExercise(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      notes: notes ?? this.notes,
      order: order ?? this.order,
      isAlternative: isAlternative ?? this.isAlternative,
      alternative: alternative ?? this.alternative,
      sets: sets ?? this.sets,
    );
  }
}
