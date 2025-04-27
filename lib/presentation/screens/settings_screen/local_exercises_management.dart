import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';
import '../../../generated/l10n.dart';
import 'add_local_exercise.dart';

class LocalExercisesManagement extends StatefulWidget {
  const LocalExercisesManagement({super.key});

  @override
  State<LocalExercisesManagement> createState() =>
      _LocalExercisesManagementState();
}

class _LocalExercisesManagementState extends State<LocalExercisesManagement> {
  List<Map<String, dynamic>> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.local_exercises_management_title,
            style: TextStyle(fontSize: 25)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddLocalExercise()),
              );

              if (result == true) {
                _loadExercises();
              }
            },
          ),
        ],
      ),
      body: _exercises.isEmpty
          ? Center(child: Text(S.current.no_local_exercises))
          : ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: exercise['image'] != null
                        ? Image.file(File(exercise['image']),
                            width: 60, height: 60, fit: BoxFit.cover)
                        : const Icon(Icons.fitness_center),
                    title: Text(exercise['name']),
                    subtitle: Text(MuscularGroupFormatter.translate(
                      MuscularGroup.values.firstWhere(
                        (e) => e.name == exercise['muscular_group'],
                      ),
                    )),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editExercise(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteExercise(index),
                        ),
                      ],
                    ),
                    onTap: () => _editExercise(index),
                  ),
                );
              },
            ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }

  Future<void> _loadExercises() async {
    final appDir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${appDir.path}/custom_exercises.json');

    if (await jsonFile.exists()) {
      final content = await jsonFile.readAsString();
      final data = json.decode(content) as List;
      setState(() {
        _exercises = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _deleteExercise(int index) async {
    final appDir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${appDir.path}/custom_exercises.json');

    setState(() {
      _exercises.removeAt(index);
    });

    await jsonFile.writeAsString(json.encode(_exercises));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.current.exercise_deleted)),
    );
  }

  Future<void> _editExercise(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLocalExercise(
          exerciseToEdit: _exercises[index],
          exerciseIndex: index,
        ),
      ),
    );

    if (result == true) {
      _loadExercises();
    }
  }
}
