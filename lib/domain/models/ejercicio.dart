import 'package:train_track/domain/models/enum/grupo_muscular.dart';

class Ejercicio {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final GrupoMuscular grupoMuscular;

  Ejercicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.grupoMuscular,
  });
}