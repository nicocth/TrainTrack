import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/custom_exercise.dart';

class ExerciseBox extends ConsumerWidget {
  final CustomExercise customExercise;
  const ExerciseBox({required this.customExercise, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 150), 
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, 
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              customExercise.exercise.image,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded( 
            child: Text(
              customExercise.exercise.name,
              style: const TextStyle(color: Colors.white),
              maxLines: 4, 
              overflow: TextOverflow.ellipsis, 
              softWrap: true, 
            ),
          ),
        ],
      ),
    );
  }
}
