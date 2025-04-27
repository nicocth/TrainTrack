import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/mappers/exercise_mapper.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';
import 'package:train_track/presentation/widgets/shared/zoomable_image.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  AddExerciseScreenState createState() => AddExerciseScreenState();
}

class AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final Set<Exercise> selectedExercises = {};
  List<Exercise> availableExercises = [];
  List<Exercise> filteredExercises = [];
  String searchQuery = "";
  MuscularGroup? selectedGroup;

  @override
  void initState() {
    super.initState();
    _loadExerciseFromJson();
  }

  void _filterExercises() {
    setState(() {
      filteredExercises = availableExercises.where((exercise) {
        final matchesSearch =
            exercise.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesGroup =
            selectedGroup == null || exercise.muscularGroup == selectedGroup;
        return matchesSearch && matchesGroup;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainingNotifier = ref.read(createTrainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(S.current.add_exercise)),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: S.current.search_exercise,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterExercises();
                });
              },
            ),
          ),

          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<MuscularGroup?>(
              isExpanded: true,
              value: selectedGroup,
              hint: Text(S.current.select_muscular_group),
              onChanged: (group) {
                setState(() {
                  selectedGroup = group;
                  _filterExercises();
                });
              },
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(S.current.all_muscular_groups),
                ),
                ...MuscularGroup.values.map((group) => DropdownMenuItem(
                      value: group,
                      // Custom class to translate the contents of MuscularGroup
                      child: Text(MuscularGroupFormatter.translate(group)),
                    )),
              ],
            ),
          ),

          // Exercise List
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                final isSelected = selectedExercises.contains(exercise);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListTile(
                    leading: ZoomableImage(exercise: exercise),
                    title: Text(exercise.name),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.green : null,
                    ),
                    onTap: () {
                      setState(() {
                        isSelected
                            ? selectedExercises.remove(exercise)
                            : selectedExercises.add(exercise);
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Add Selected Button
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
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
    final defaultExercises =
        await ExerciseMapper.fromJsonList(); // read from assets

    final customExercises =
        await ExerciseMapper.fromLocalJsonList(); // read from local file

    setState(() {
      availableExercises = [...defaultExercises, ...customExercises];
      filteredExercises = availableExercises;
    });
  }
}
