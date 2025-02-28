import 'dart:convert';
import 'package:flutter/services.dart';
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
      muscularGroup: MuscularGroup.values.firstWhere(
        (e) => e.name == json['muscular_group'], // Convierte string a enum
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
      'muscular_group': exercise.muscularGroup,
    };
  }

  /// Convert list from exercise.json to a list of `Exercise` objects
  static Future<List<Exercise>> fromJsonList() async {
    final String jsonString = await rootBundle.loadString('lib/core/data/exercise.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Convert a list of `Exercise` objects to a JSON list
  static String toJsonList(List<Exercise> exercises) {
    final List<Map<String, dynamic>> jsonList = 
        exercises.map((exercise) => toJson(exercise)).toList();
    return json.encode(jsonList);
  }
}
