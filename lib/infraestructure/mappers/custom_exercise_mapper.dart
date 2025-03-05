import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_track/domain/models/sets.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/infraestructure/mappers/exercise_mapper.dart';

class CustomExerciseMapper {
  static Future<CustomExercise> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final exerciseRef = await ExerciseMapper.getExerciseById(data['exercise']);

    return CustomExercise(
      exercise: exerciseRef,
      notes: data['notes'] ?? '',
      order: data['order'] ?? 0,
      alternative: data['alternative'],
      sets: (data['sets'] as List<dynamic>).map((set) {
        return Sets(
          reps: set['reps'] ?? 0,
          weight: (set['weight'] as num).toDouble(),
        );
      }).toList(),
    );
  }
}
