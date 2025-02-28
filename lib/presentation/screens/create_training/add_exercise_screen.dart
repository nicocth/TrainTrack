import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/mappers/exercise_mapper.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  AddExerciseScreenState createState() => AddExerciseScreenState();
}

class AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final Set<Exercise> selectedExercises = {};
  List<Exercise> availableExercises = [];

  @override
  void initState() {
    super.initState();
    _loadExerciseFromJson();
  }

  @override
  Widget build(BuildContext context) {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(S.current.add_exercise)),
      body: Column(
        children: [
          Expanded(
            //List of available exercise
            child: ListView.builder(
              itemCount: availableExercises.length,
              itemBuilder: (context, index) {
                final exercise = availableExercises[index];
                final isSelected = selectedExercises.contains(exercise);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: ListTile(
                      // Exercise image
                      leading: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10),
                                child: Image.asset(
                                  exercise.image,
                                  fit: BoxFit
                                      .contain, 
                                ),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(100), 
                          child: Image.asset(
                            exercise.image,
                            width: 60,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Exercise title
                      title: SizedBox(height: 60, child: Text(exercise.name)),

                      // Select icon
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? Colors.green : null,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedExercises.remove(exercise);
                          } else {
                            selectedExercises.add(exercise);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Button to add selected exercises
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: selectedExercises.isEmpty
                  ? null
                  : () {
                      trainingNotifier.addExercises(selectedExercises.toList());
                      Navigator.pop(context);
                    },
              child: Text(S.current.add_selected),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadExerciseFromJson() async {
    List<Exercise> exerciseList = await ExerciseMapper.fromJsonList();
    setState(() {
      availableExercises = exerciseList;
    });
  }
}
