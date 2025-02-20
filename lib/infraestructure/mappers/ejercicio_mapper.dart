import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:train_track/domain/models/enum/grupo_muscular.dart';

import '../../domain/models/ejercicio.dart';

class EjercicioMapper {
  /// Convierte un JSON en un objeto `Ejercicio`
  static Ejercicio fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      grupoMuscular: GrupoMuscular.values.firstWhere(
        (e) => e.name == json['grupo_muscular'], // Convierte string a enum
      ),
    );
  }

  /// Convierte un objeto `Ejercicio` en un mapa JSON
  static Map<String, dynamic> toJson(Ejercicio ejercicio) {
    return {
      'id': ejercicio.id,
      'nombre': ejercicio.nombre,
      'descripcion': ejercicio.descripcion,
      'imagen': ejercicio.imagen,
      'grupo_muscular': ejercicio.grupoMuscular,
    };
  }

  /// Convierte la lista de exercise.json en una lista de objetos `Ejercicio`
  static Future<List<Ejercicio>> fromJsonList() async {
    final String jsonString = await rootBundle.loadString('lib/shared/data/exercise.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Convierte una lista de objetos `Ejercicio` en una lista JSON
  static String toJsonList(List<Ejercicio> ejercicios) {
    final List<Map<String, dynamic>> jsonList = 
        ejercicios.map((ejercicio) => toJson(ejercicio)).toList();
    return json.encode(jsonList);
  }
}
