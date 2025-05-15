import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/training_session_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_name.dart';
import 'package:train_track/presentation/widgets/shared/zoomable_image.dart';

class ExerciseCardTraining extends ConsumerWidget {
  final CustomExercise customExercise;
  final TextEditingController notesController;
  final List<TextEditingController> repsControllers;
  final List<TextEditingController> weightControllers;

  const ExerciseCardTraining({
    super.key,
    required this.customExercise,
    required this.notesController,
    required this.repsControllers,
    required this.weightControllers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSessionNotifier = ref.read(trainingSessionProvider.notifier);
    final trainingSessionState = ref.watch(trainingSessionProvider);

    assert(repsControllers.length == customExercise.sets.length);
    assert(weightControllers.length == customExercise.sets.length);

    final List<String> headers = [
      "\u2713",
      S.current.series,
      S.current.kg_text,
      S.current.reps_text,
      ""
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ZoomableImage(exercise: customExercise.exercise),
                const SizedBox(width: 20),
                ExerciseName(customExercise: customExercise)
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: S.current.notes,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      headers.length,
                      (index) => SizedBox(
                        width: index == 0 ? 30 : 50,
                        child: Center(
                          child: Text(
                            headers[index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 5),
                Column(
                  children: List.generate(customExercise.sets.length, (index) {
                    final isChecked = trainingSessionState
                        .completedSets[customExercise.order]
                        .contains(index);
                    return Container(
                      color:
                          isChecked ? Color.fromRGBO(115, 255, 0, 0.2) : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                if (value == true) {
                                  trainingSessionNotifier.markSetAsCompleted(
                                      customExercise.order, index);
                                } else {
                                  trainingSessionNotifier.markSetAsNotCompleted(
                                      customExercise.order, index);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                              width: 50,
                              child: Center(child: Text("${index + 1}"))),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: weightControllers[index],
                              keyboardType: TextInputType.number,
                              inputFormatters: [DecimalTextInputFormatter()],
                              decoration:
                                  InputDecoration(hintText: S.current.kg),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: repsControllers[index],
                              keyboardType: TextInputType.number,
                              inputFormatters: [IntegerTextInputFormatter()],
                              decoration:
                                  InputDecoration(hintText: S.current.reps),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              trainingSessionNotifier.removeSetFromExercise(
                                  customExercise.order, index);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                trainingSessionNotifier.addSetToExercise(customExercise.order);
              },
              icon: const Icon(Icons.add),
              label: Text(S.current.add_series),
            ),
          ],
        ),
      ),
    );
  }
}
