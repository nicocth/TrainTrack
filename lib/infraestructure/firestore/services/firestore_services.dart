import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:train_track/domain/models/training.dart';
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
  Future<Result> saveTraining(WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);
    final userId = authNotifier.getUserId();

    final newTraining = ref.read(createTrainingProvider);
    final createTrainingNotifier = ref.read(createTrainingProvider.notifier);

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
        final exerciseData = {
          'exercise': newTraining.customExercises[i].exercise.id,
          'order': i,
          'name': newTraining.customExercises[i].exercise.name,
          'is_alternative': newTraining.customExercises[i].isAlternative,
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
        };

        // Add 'alternative' only if isAlternative is true
        if (newTraining.customExercises[i].isAlternative) {
          exerciseData['alternative'] =
              int.tryParse(newTraining.alternativeControllers[i].text) ?? 0;
        }

        await routineDoc.collection('exercises').add(exerciseData);
      }

      //clear all data from provider
      createTrainingNotifier.reset();

      return Result.success();
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result> updateTraining(WidgetRef ref, String trainingId) async {
    final authNotifier = ref.read(authProvider.notifier);
    final userId = authNotifier.getUserId();

    final updatedTraining = ref.read(createTrainingProvider);
    final updatedTrainingNotifier = ref.read(createTrainingProvider.notifier);

    try {
      final trainingRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .doc(trainingId);

      await trainingRef.update({
        'title': updatedTraining.titleController.text,
        'date_updated': Timestamp.now(),
      });

      final exercisesRef = trainingRef.collection('exercises');
      final existingExercises = await exercisesRef.get();
      for (final doc in existingExercises.docs) {
        await doc.reference.delete();
      }

      for (int i = 0; i < updatedTraining.customExercises.length; i++) {
        final exerciseData = {
          'exercise': updatedTraining.customExercises[i].exercise.id,
          'order': i,
          'name': updatedTraining.customExercises[i].exercise.name,
          'is_alternative': updatedTraining.customExercises[i].isAlternative,
          'notes': updatedTraining.notesControllers[i].text,
          'sets':
              List.generate(updatedTraining.customExercises[i].sets.length, (j) {
            return {
              'weight':
                  double.tryParse(updatedTraining.weightControllers[i][j].text) ??
                      0.0,
              'reps': int.tryParse(updatedTraining.repsControllers[i][j].text) ?? 0,
            };
          }),
        };

        // Add 'alternative' only if isAlternative is true
        if (updatedTraining.customExercises[i].isAlternative) {
          exerciseData['alternative'] =
              int.tryParse(updatedTraining.alternativeControllers[i].text) ?? 0;
        }

        await exercisesRef.add(exerciseData);
      }

      //clear all data from provider
      updatedTrainingNotifier.reset();

      return Result.success();
    } catch (e) {
      return Result.failure('Error updating training: $e');
    }
  }

  Future<Result> deleteTraining(String? userId, String trainingId) async {
    try {
      final trainingRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .doc(trainingId);

      // Get the subcollection
      final subcollections = ['exercises'];

      for (final subcollection in subcollections) {
        final subcollectionRef = trainingRef.collection(subcollection);
        final querySnapshot = await subcollectionRef.get();

        for (final doc in querySnapshot.docs) {
          //Delete the subcollection
          await doc.reference.delete();
        }
      }

      // Delete main doc
      await trainingRef.delete();

      return Result.success();
    } catch (e) {
      return Result.failure('Error deleting training: $e');
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
        trainingsSnapshot.docs
            .map((doc) => TrainingMapper.fromFirestore(doc, userId)),
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
