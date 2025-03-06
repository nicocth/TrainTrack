import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/providers/trainings_provider.dart';
import 'package:train_track/presentation/screens/create_training/create_training_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';
import 'package:train_track/presentation/screens/training_session/training_summary_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Makes sure to listen when you return to this screen and refresh the list
    ref.read(trainingsProvider.notifier).loadTrainings(ref);
  }

  @override
  Widget build(BuildContext context) {
    final trainingsState = ref.watch(trainingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.home),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              })
        ],
      ),
      body: Column(
        children: [
          // Add training button
          ListTile(
            title: Text(S.current.create_training),
            trailing: const Icon(Icons.add),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTrainingScreen(),
                ),
              );

              // Only refresh if the new training is saved
              if (result == true) {
                ref.read(trainingsProvider.notifier).loadTrainings(ref);
              }
            },
          ),

          // List title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.my_trainings,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // Trainings list
          Expanded(
            child: trainingsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : trainingsState.errorMessage != null
                    ? Center(child: Text(S.current.error_loading_training_list))
                    : trainingsState.trainings.isEmpty
                        ? Center(child: Text(S.current.empty_training_list))
                        : ListView.builder(
                            itemCount: trainingsState.trainings.length,
                            itemBuilder: (context, index) {
                              final training = trainingsState.trainings[index];

                              // Find the image with order == 0
                              final customExerciseImage = training.exercises
                                  .firstWhere(
                                    (exercise) => exercise.order == 0,
                                    orElse: () => training.exercises.first,
                                  )
                                  .exercise
                                  .image;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TrainingSummaryScreen(
                                              training: training),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Background image
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                              customExerciseImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        // Opacity layer
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.3),
                                            ),
                                          ),
                                        ),

                                        // Options icon in top right corner
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert,
                                                color: Colors.white),
                                            onSelected: (String value) {
                                              if (value == 'edit') {
                                                final newTrainingNotifier = ref
                                                    .read(createTrainingProvider
                                                        .notifier);
                                                newTrainingNotifier
                                                    .loadTraining(training);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateTrainingScreen(
                                                            trainingId:
                                                                training.id),
                                                  ),
                                                ).then((result) {
                                                  if (result == true) {
                                                    ref
                                                        .read(trainingsProvider
                                                            .notifier)
                                                        .loadTrainings(ref);
                                                  }
                                                });
                                              } else if (value == 'delete') {
                                                _showDeleteConfirmationDialog(
                                                    context, training.id);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Text(S.current.edit),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text(S.current.delete),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Training name
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(training.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String trainingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.confirm_delete),
        content: Text(S.current.confirm_delete_message_training),
        actions: [
          TextButton(
            //Close popup
            onPressed: () => Navigator.pop(context),
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () {
              //Close popup and delete training
              Navigator.pop(context);
              ref
                  .read(trainingsProvider.notifier)
                  .deleteTraining(ref, trainingId);
            },
            child: Text(S.current.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
