import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para crear un usuario en Firestore
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

  // Método privado para inicializar las subcolecciones
  Future<void> _initializeSubcollections(String userId) async {
    const subcollections = ['trainings', 'record', 'prs'];

    for (var collection in subcollections) {
      await _firestore.collection('users')
      .doc(userId)
      .collection(collection)
      .add({});
    }
  }
}

// Definir una clase para manejar el resultado de la operación
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
