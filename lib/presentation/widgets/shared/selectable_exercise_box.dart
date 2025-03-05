import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/exercise.dart';

class SelectableExerciseBox extends ConsumerWidget {
  final Exercise exercise;
  const SelectableExerciseBox({required this.exercise , super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[300],
            radius: 10,
          ),
          SizedBox(width: 8),
          Text(
            exercise.name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 8),
          Checkbox(value: true, onChanged: (value) {}),
        ],
      ),
    );
  }
}
