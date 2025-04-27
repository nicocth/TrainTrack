import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/presentation/widgets/shared/exercise_image.dart';

class ZoomableImage extends ConsumerWidget {
  final Exercise exercise;
  final double thumbnailSize;
  final double zoomedSize;

  const ZoomableImage({
    super.key,
    required this.exercise,
    this.thumbnailSize = 60,
    this.zoomedSize = 300,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showZoomedImage(context),
      child: ClipOval(
        child: ExerciseImage(
          exercise: exercise,
          width: thumbnailSize,
          height: thumbnailSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showZoomedImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: zoomedSize,
            maxHeight: zoomedSize,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ExerciseImage(
              exercise: exercise,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}