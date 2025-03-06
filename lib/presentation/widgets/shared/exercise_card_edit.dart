// Custom card for edit CustomExercise
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/custom_exercise.dart';
import 'package:train_track/domain/models/sets.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/zoomable_image.dart';

class ExerciseCard extends ConsumerWidget {
  final int exerciseIndex;
  final CustomExercise customExercise;
  final TextEditingController alternativeController;
  final TextEditingController notesController;
  final List<TextEditingController> repsControllers;
  final List<TextEditingController> weightControllers;
  final VoidCallback onDelete;

  const ExerciseCard(
      {super.key,
      required this.exerciseIndex,
      required this.customExercise,
      required this.alternativeController,
      required this.notesController,
      required this.repsControllers,
      required this.weightControllers,
      required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createTrainingNotifier = ref.read(createTrainingProvider.notifier);

    final List<String> headers = [
      S.current.series,
      S.current.kg_text,
      S.current.reps_text
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper section with image, name and delete button
            Row(
              children: [
                ZoomableImage(image: customExercise.exercise.image),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    customExercise.exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDelete();
                  },
                ),
              ],
            ),

            //Spacer
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: alternativeController,
                    keyboardType: TextInputType.number,
                    enabled: customExercise.isAlternative,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      hintText: S.current.hint_alternative_text,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Switch(
                  value: customExercise.isAlternative,
                  onChanged: (bool value) {
                    createTrainingNotifier.toggleAlternative(exerciseIndex);
                    if (!value) {
                      alternativeController.clear();
                    }
                  },
                ),
              ],
            ),

            //Spacer
            const SizedBox(height: 5),

            //Notes field
            SizedBox(
              height: 50,
              child: TextField(
                controller: notesController,
                onChanged: (value) {
                  notesController.text = value;
                },
                decoration: InputDecoration(
                  labelText: S.current.notes,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            //Spacer
            const SizedBox(height: 10),

            //Sets table header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    headers.length,
                    (index) => SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          headers[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ).expand((widget) => [widget, SizedBox(width: 50)]).toList()
                    ..removeLast(),
                ),

                //Spacer
                const SizedBox(height: 5),

                // Sets lists
                Column(
                  children: List.generate(customExercise.sets.length, (index) {
                    return Row(
                      children: [
                        //Order
                        SizedBox(
                            width: 50,
                            child: Center(child: Text("${index + 1}"))),
                        //Spacer
                        const SizedBox(width: 50),

                        // Field for Kg
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: weightControllers[index],
                            keyboardType: TextInputType.number,
                            inputFormatters: [DecimalTextInputFormatter()],
                            decoration: InputDecoration(hintText: S.current.kg),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        //Spacer
                        SizedBox(width: 50),

                        //Field for Reps
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

                        //Spacer
                        SizedBox(width: 5),

                        //Button delete
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            createTrainingNotifier.removeSetFromExercise(
                                exerciseIndex, index);
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),

            // Button to add sets
            TextButton.icon(
              onPressed: () {
                createTrainingNotifier.addSetToExercise(
                    exerciseIndex, Sets(reps: 0, weight: 0));
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
