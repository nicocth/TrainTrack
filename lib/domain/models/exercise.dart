import 'package:train_track/domain/models/enum/muscular_group.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String image;
  final MuscularGroup muscularGroup;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.muscularGroup,
  });
}