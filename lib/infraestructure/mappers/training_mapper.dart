import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/infraestructure/mappers/custom_exercise_mapper.dart';

class TrainingMapper {
  static Future<Training> fromFirestore(DocumentSnapshot doc, String? userId) async {
    final data = doc.data() as Map<String, dynamic>;
    
    final exercisesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('trainings')
        .doc(doc.id)
        .collection('exercises')
        .get();

    List<CustomExercise> exercises = await Future.wait(
      exercisesSnapshot.docs.map((exerciseDoc) async {
        return await CustomExerciseMapper.fromFirestore(exerciseDoc);
      }),
    );

    return Training(
      id: doc.id,
      name: data['title'] ?? 'Unnamed Training',
      dateCreated: (data['date_created'] as Timestamp).toDate(),
      dateUpdated: (data['date_updated'] as Timestamp).toDate(),
      exercises: exercises,
    );
  }
}