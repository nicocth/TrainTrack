import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/providers/trainings_provider.dart';
import 'package:train_track/presentation/widgets/shared/exercise_card_edit.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';
import 'add_exercise_screen.dart';

class CreateTrainingScreen extends ConsumerStatefulWidget {
  final String? trainingId; //optional parameter to edit

  const CreateTrainingScreen({super.key, this.trainingId});

  @override
  ConsumerState<CreateTrainingScreen> createState() =>
      _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends ConsumerState<CreateTrainingScreen> {
  bool isCompactMode = false;
  final FocusNode _dummyFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _dummyFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newTraining = ref.watch(createTrainingProvider);
    final newTrainingNotifier = ref.read(createTrainingProvider.notifier);

    return PopScope(
      canPop: widget.trainingId == null, // If it's not editing, just exit
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && widget.trainingId != null) {
          // If it's editing and user tries to exit
          final shouldExit = await _showExitConfirmationDialog(context);
          if (shouldExit) {
            ref.invalidate(createTrainingProvider);
            if (context.mounted) Navigator.of(context).pop();
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.trainingId != null
                  ? S.current.edit_routine
                  : S.current.create_routine,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(isCompactMode ? Icons.article : Icons.view_list),
                tooltip: isCompactMode
                    ? S.current.detailed_mode
                    : S.current.compact_mode,
                onPressed: () {
                  setState(() {
                    isCompactMode = !isCompactMode;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.save),
                tooltip: S.current.save,
                onPressed: () => _saveTraining(context, ref),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Training title
                  TextField(
                    controller: newTraining.titleController,
                    decoration:
                        InputDecoration(labelText: S.current.routine_title),
                  ),

                  const SizedBox(height: 20), // Spacer

                  // ExerciseCard list
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      newTrainingNotifier.reorderExercise(oldIndex, newIndex);
                    },
                    children: List.generate(
                      newTraining.customExercises.length,
                      (index) {
                        final exercise = newTraining.customExercises[index];
                        return isCompactMode
                            ? ListTile(
                                key: ValueKey(
                                    'compact-${exercise.exercise.id}$index'),
                                title: Text(exercise.exercise.name),
                                trailing: const Icon(Icons.drag_handle),
                              )
                            : ExerciseCard(
                                key: ValueKey('${exercise.exercise.id}$index'),
                                exerciseIndex: index,
                                customExercise: exercise,
                                alternativeController:
                                    newTraining.alternativeControllers[index],
                                notesController:
                                    newTraining.notesControllers[index],
                                repsControllers:
                                    newTraining.repsControllers[index],
                                weightControllers:
                                    newTraining.weightControllers[index],
                                onDelete: () {
                                  newTrainingNotifier.removeExercise(index);
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: S.current.add_exercise,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              FocusScope.of(context).requestFocus(_dummyFocusNode);

              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddExerciseScreen()),
              );
              // After returning, animate scroll at the end
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
          ),
          bottomNavigationBar: const TrainingSessionBanner(),
        ),
      ),
    );
  }

  Future<void> _saveTraining(BuildContext context, WidgetRef ref) async {
    final newTraining = ref.read(createTrainingProvider);

    // Check title is not empty
    if (newTraining.titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_title)),
      );
      return;
    }

    // Check exercises are not empty
    if (newTraining.customExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.empty_exercises_list)),
      );
      return;
    }

    try {
      final FirestoreService firestoreService = FirestoreService();
      bool isEditing = widget.trainingId != null;

      final result = isEditing
          ? await firestoreService
              .updateTrainingFromEdit(ref, widget.trainingId!)
              .timeout(Duration(seconds: 6), onTimeout: () {
              throw TimeoutException(S.current
                  .request_timeout); // Add timeout in case the user is left without connection
            })
          : await firestoreService
              .saveTraining(ref)
              .timeout(Duration(seconds: 6), onTimeout: () {
              throw TimeoutException(S.current.request_timeout);
            });

      // Refresh the trainings list after saving
      ref.read(trainingsProvider.notifier).loadTrainings(ref);

      // Check if widget is mounted before displaying snackbar
      if (!context.mounted) return;

      if (result.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.error_saving_routine)),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.training_saved)),
      );

      // Return true if the training is success for refresh home
      Navigator.pop(context, true);
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.request_timeout)),
      );
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.current.unsaved_changes),
            content: Text(S.current.exit_confirmation),
            actions: [
              TextButton(
                child: Text(S.current.discard),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextButton(
                child: Text(S.current.cancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ) ??
        false; // In case the dialog is closed without choosing an option, return false
  }
}
