import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/ejercicio.dart';

class EjercicioMapper {
  static Ejercicio fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Ejercicio(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      imagen: data['imagen'] ?? '',
      grupoMuscular: data['grupo_muscular'] ?? '',
    );
  }

  static Map<String, dynamic> toFirestore(Ejercicio ejercicio) {
    return {
      'nombre': ejercicio.nombre,
      'descripcion': ejercicio.descripcion,
      'imagen': ejercicio.imagen,
      'grupoMuscular': ejercicio.grupoMuscular,
    };
  }
}
