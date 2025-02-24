import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';

import '../../domain/models/exercise.dart';

class ExerciseMapper {
  /// Convierte un JSON en un objeto `Exercise`
  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      muscularGroup: MuscularGroup.values.firstWhere(
        (e) => e.name == json['muscular_group'], // Convierte string a enum
      ),
    );
  }

  /// Convierte un objeto `Exercise` en un mapa JSON
  static Map<String, dynamic> toJson(Exercise exercise) {
    return {
      'id': exercise.id,
      'name': exercise.name,
      'description': exercise.description,
      'image': exercise.image,
      'muscular_group': exercise.muscularGroup,
    };
  }

  /// Convierte la lista de exercise.json en una lista de objetos `Exercise`
  static Future<List<Exercise>> fromJsonList() async {
    final String jsonString = await rootBundle.loadString('lib/shared/data/exercise.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Convierte una lista de objetos `Exercise` en una lista JSON
  static String toJsonList(List<Exercise> exercises) {
    final List<Map<String, dynamic>> jsonList = 
        exercises.map((exercise) => toJson(exercise)).toList();
    return json.encode(jsonList);
  }
}
