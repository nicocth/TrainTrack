import 'package:flutter/material.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/training_history.dart';

class TrainingHistoryBottomSheet extends StatelessWidget {
  final TrainingHistory history;

  const TrainingHistoryBottomSheet({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final orderedExercises = List<CustomExercise>.from(history.exercises)
      ..sort((a, b) => a.order.compareTo(b.order));

    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            controller: scrollController,
            itemCount: orderedExercises.length,
            itemBuilder: (context, index) {
              final customExercise = orderedExercises[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customExercise.exercise.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (customExercise.notes.isNotEmpty)
                        Text(
                          'Notas: ${customExercise.notes}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: customExercise.sets.length,
                        itemBuilder: (context, setIndex) {
                          final set = customExercise.sets[setIndex];
                          return Text(
                            'Set ${setIndex + 1}: ${set.reps} reps x ${set.weight} kg',
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
