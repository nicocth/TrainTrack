import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/infraestructure/mappers/custom_exercise_mapper.dart';
import 'package:train_track/infraestructure/mappers/training_mapper.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a document to the users collection for new user
  Future<Result> createUserInFirestore(String email, String userId) async {
    String creationDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // Crear el documento en Firestore con los datos básicos
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'email': email,
        'creation_date': creationDate,
        'profile_image': '', // URL vacía por defecto
        'nickname': '', // Se puede llenar después
        'last_access': creationDate,
      });

      // Inicializar las subcolecciones
      await _initializeSubcollections(userId);

      return Result.success();
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // TODO: Consider deleting it
  // Private method to initialize subcollections
  Future<void> _initializeSubcollections(String userId) async {
    const subcollections = ['trainings', 'record', 'prs'];

    for (var collection in subcollections) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .add({});
    }
  }

  // Method to save a Custom training
  Future<Result> saveTraining( WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    final userId = authNotifier.getUserId();

    final newTraining = ref.read(trainingProvider);
    final trainingNotifier = ref.read(trainingProvider.notifier);

    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final routinesRef = userRef.collection('trainings');

      final routineDoc = await routinesRef.add({
        'title': newTraining.titleController.text,
        'date_created': Timestamp.now(),
        'date_updated': Timestamp.now(),
      });

      for (int i = 0; i < newTraining.customExercises.length; i++) {
        await routineDoc.collection('exercises').add({
          'exercise': newTraining.customExercises[i].exercise.id,
          'order': i,
          'name': newTraining.customExercises[i].exercise.name,
          'notes': newTraining.notesControllers[i].text,
          'sets':
              List.generate(newTraining.customExercises[i].sets.length, (j) {
            return {
              'weight':
                  double.tryParse(newTraining.weightControllers[i][j].text) ??
                      0.0,
              'reps': int.tryParse(newTraining.repsControllers[i][j].text) ?? 0,
            };
          }),
        });
      }

      //clear all data from provider
      trainingNotifier.reset();

      return Result.success();
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // Method to fetch CustomExercise list
 Future<List<Training>> getAllTrainings(String? userId) async {
    try {
      final trainingsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .get();

      List<Training> trainings = await Future.wait(
        trainingsSnapshot.docs.map((doc) => TrainingMapper.fromFirestore(doc, userId)),
      );

      return trainings;
    } catch (e) {
      throw Exception('Error fetching trainings: $e');
    }
  }
}

// class to handle the result of the operation
class Result {
  final bool success;
  final String? errorMessage;

  Result._(this.success, [this.errorMessage]);

  factory Result.success() {
    return Result._(true);
  }

  factory Result.failure(String error) {
    return Result._(false, error);
  }

  bool get isSuccess => success;
  bool get isFailure => !success;
}
