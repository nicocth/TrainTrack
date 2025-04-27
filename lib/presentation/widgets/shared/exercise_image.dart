import 'package:flutter/material.dart';
import 'package:train_track/domain/models/exercise.dart';

class ExerciseImage extends StatelessWidget {
  final Exercise exercise;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ExerciseImage({
    super.key,
    required this.exercise,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: exercise.imageProvider,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
    );
  }
}