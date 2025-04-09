import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/training_history.dart';
import 'package:train_track/infraestructure/mappers/custom_exercise_mapper.dart';

class TrainingHistoryMapper {
  static Future<TrainingHistory> fromFirestore(DocumentSnapshot doc, String? userId) async {
    final data = doc.data() as Map<String, dynamic>;
    
    final exercisesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('training_history')
        .doc(doc.id)
        .collection('exercises')
        .get();

    List<CustomExercise> exercises = await Future.wait(
      exercisesSnapshot.docs.map((exerciseDoc) async {
        return await CustomExerciseMapper.fromFirestore(exerciseDoc);
      }),
    );

    return TrainingHistory(
      id: doc.id,
      name: data['title'] ?? 'Unnamed Training',
      trainingDate: (data['training_date'] as Timestamp).toDate(),
      exercises: exercises,
    );
  }
}