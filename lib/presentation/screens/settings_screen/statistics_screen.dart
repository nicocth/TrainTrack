import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';
import 'package:train_track/domain/models/exercise.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/training_history.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/infraestructure/mappers/exercise_mapper.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  // Number of months to show in the statistics
  int selectedMonths = 3;
  // Number of exercises done for each muscle group
  Map<MuscularGroup, int> trainingCounts = {};
  // State to control the display mode of the radar chart
  bool showAbsoluteValues = true;
  // Collection of exercises necessary to know the muscle group of the exercise obtained in firestore
  List<Exercise> availableExercises = [];
  bool isLoading = true;
  // We initialize counters for the cards
  int totalTrainings = 0;
  int totalSets = 0;
  int totalExercises = 0;
  int totalReps = 0;

  @override
  void initState() {
    super.initState();
    _loadExercisesAndData();
  }

  @override
  Widget build(BuildContext context) {
    // We initialize the range of values ​​to be displayed on the radar chart
    final values = MuscularGroup.values
        .map((group) => trainingCounts[group] ?? 0)
        .toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: Text(S.current.statistics)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Month selector
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedMonths,
                      items: [1, 3, 6, 12].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value == 1
                                ? '$value ${S.current.month}'
                                : '$value ${S.current.months}',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedMonths = value;
                            isLoading = true;
                          });
                          _getTrainingData(availableExercises).then((_) {
                            setState(() => isLoading = false);
                          });
                        }
                      },
                    ),
                  ),

                  // Absolute/Percentage Change Button
                  _buildToggleButton(),

                  // Radar chart
                  SizedBox(
                    height: 340,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: RadarChart(
                        RadarChartData(
                          radarBorderData:
                              BorderSide(color: Theme.of(context).dividerColor),
                          dataSets: [
                            RadarDataSet(
                              dataEntries: _getDataEntries(),
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.3),
                              borderColor: Theme.of(context).primaryColor,
                              borderWidth: 2,
                            ),
                          ],
                          radarBackgroundColor: Colors.transparent,
                          titleTextStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 12,
                          ),
                          getTitle: (index, angle) {
                            final group = MuscularGroup.values[index];
                            final value = trainingCounts[group] ?? 0;
                            final displayValue = showAbsoluteValues
                                ? value.toString()
                                : maxValue > 0
                                    ? '${((value / maxValue) * 100).toStringAsFixed(0)}%'
                                    : '0%';

                            return RadarChartTitle(
                              text:
                                  '${MuscularGroupFormatter.translate(group)}\n$displayValue',
                              angle: angle,
                            );
                          },
                          tickCount: 5,
                          ticksTextStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Summary Cards
                  _buildSummaryCards(),
                ],
              ),
            ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }

  Future<void> _loadExercisesAndData() async {
    try {
      final exerciseList = await ExerciseMapper.fromJsonList();
      await _getTrainingData(exerciseList);

      setState(() {
        availableExercises = exerciseList;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.error_loading_data)),
      );
    }
  }

  Future<void> _getTrainingData(List<Exercise> exercises) async {
    try {
      // Get the training history data from Firestore
      final List<TrainingHistory> trainingHistoryList =
          await FirestoreService().getTrainingHistoryData(selectedMonths);

      // We initialize counters
      Map<MuscularGroup, int> muscleGroupCounts = {
        for (var group in MuscularGroup.values) group: 0
      };
      int trainingCount = 0;
      int setsCount = 0;
      int exercisesCount = 0;
      int repsCount = 0;

      for (var traininHistory in trainingHistoryList) {
        // We count one training for each document
        trainingCount++;

        // We count one exercise for each collection
        final customExercisesList = traininHistory.exercises;
        exercisesCount += customExercisesList.length;

        for (var customExercise in customExercisesList) {
          // We add the series of each exercise
          setsCount += customExercise.sets.length;

          // We add the reps of each sets
          for (var setData in customExercise.sets) {
            repsCount += setData.reps;
          }

          muscleGroupCounts[customExercise.exercise.muscularGroup] =
              (muscleGroupCounts[customExercise.exercise.muscularGroup] ?? 0) +
                  customExercise.sets.length;
        }
      }

      setState(() {
        trainingCounts = muscleGroupCounts;
        totalTrainings = trainingCount;
        totalSets = setsCount;
        totalExercises = exercisesCount;
        totalReps = repsCount;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.error_loading_training_list)),
      );
    }
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Column(
        children: [
          // First row (Trainings and Exercises)
          Row(
            children: [
              _buildSummaryCard(
                title: S.current.trainings,
                value: totalTrainings,
                icon: Icons.fitness_center,
              ),
              const SizedBox(width: 5),
              _buildSummaryCard(
                title: S.current.exercises,
                value: totalExercises,
                icon: Icons.list_alt,
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Second row (Sets and Reps)
          Row(
            children: [
              _buildSummaryCard(
                title: S.current.sets,
                value: totalSets,
                icon: Icons.format_list_numbered,
              ),
              const SizedBox(width: 5),
              _buildSummaryCard(
                title: S.current.reps_text,
                value: totalReps,
                icon: Icons.repeat,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          setState(() {
            showAbsoluteValues = !showAbsoluteValues;
          });
        },
        child: Text(showAbsoluteValues
            ? S.current.show_percentages
            : S.current.show_absolute_values),
      ),
    );
  }

  List<RadarEntry> _getDataEntries() {
    final values = MuscularGroup.values
        .map((group) => trainingCounts[group] ?? 0)
        .toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return MuscularGroup.values.map((group) {
      final value = trainingCounts[group] ?? 0;
      return RadarEntry(
        value: showAbsoluteValues
            ? value.toDouble()
            : maxValue > 0
                ? (value / maxValue * 100)
                : 0,
      );
    }).toList();
  }
}
