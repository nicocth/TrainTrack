import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';

import '../../domain/models/exercise.dart';

class ExerciseMapper {
  /// Convert a JSON to an `Exercise` object
  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isLocal: json['isLocal'] ?? false,
      muscularGroup: MuscularGroup.values.firstWhere(
        (e) => e.name == json['muscular_group'],
        orElse: () => MuscularGroup.pectoral, // Valor por defecto
      ),
    );
  }

  /// Convert an `Exercise` object to a JSON map
  static Map<String, dynamic> toJson(Exercise exercise) {
    return {
      'id': exercise.id,
      'name': exercise.name,
      'description': exercise.description,
      'image': exercise.image,
      'isLocal': exercise.isLocal,
      'muscular_group': exercise.muscularGroup.name,
    };
  }

  /// Load exercises from app assets
  static Future<List<Exercise>> fromJsonList() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/core/data/exercise.json');
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Load locally saved exercises
  static Future<List<Exercise>> fromLocalJsonList() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/custom_exercises.json');

      if (!await file.exists()) return [];

      final jsonList = json.decode(await file.readAsString()) as List;

      return jsonList.map((json) {
        // Asegurar que las imágenes locales tengan rutas absolutas
        final imagePath = json['image'].startsWith(dir.path)
            ? json['image']
            : '${dir.path}/${json['image']}';

        return fromJson(json).copyWith(
          image: imagePath,
          isLocal: true,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all exercises (both default and local)
  static Future<List<Exercise>> getAllExercises() async {
    final defaultExercises = await fromJsonList();
    final localExercises = await fromLocalJsonList();
    return [...defaultExercises, ...localExercises];
  }

  /// Get exercise by ID (searches in both default and local)
  static Future<Exercise> getExerciseById(String id) async {
    final allExercises = await getAllExercises();
    return allExercises.firstWhere(
      (exercise) => exercise.id == id,
      orElse: () => Exercise(
        id: 'not_found',
        name: 'Unknown Exercise',
        description: 'No description available',
        image: 'assets/images/default_exercise.png',
        muscularGroup: MuscularGroup.pectoral,
      ),
    );
  }

  /// Save a exercises to local storage
  static Future<void> saveLocalExercise(Map<String, String> exercise, int? exerciseIndex) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final jsonFile = File('${appDir.path}/custom_exercises.json');

      List exercises = [];
      if (await jsonFile.exists()) {
        final content = await jsonFile.readAsString();
        exercises = json.decode(content);
      }

    if (exerciseIndex != null) {
      // Editar ejercicio existente
      exercises[exerciseIndex] = exercise;
    } else {
      // Añadir nuevo ejercicio
      exercises.add(exercise);
    }

    await jsonFile.writeAsString(json.encode(exercises));
    
    } catch (e) {
      rethrow;
    }
  }
}
