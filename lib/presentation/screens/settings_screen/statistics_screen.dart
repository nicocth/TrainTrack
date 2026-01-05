import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';
import 'package:train_track/domain/models/exercise.dart';
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
  int selectedMonths = 3;
  Map<MuscularGroup, int> trainingCounts = {};
  bool showAbsoluteValues = true;
  List<Exercise> availableExercises = [];
  bool isLoading = true;

  // Summary counters
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
    // Safe maxValue
    final values = MuscularGroup.values
        .map((group) => trainingCounts[group] ?? 0)
        .toList();
    final maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1;

    return Scaffold(
      appBar: AppBar(title: Text(S.current.statistics)),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (trainingCounts.values.every((v) => v == 0))
                ? Center(child: Text(S.current.no_training_data))
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
                                child: Text(value == 1
                                    ? '$value ${S.current.month}'
                                    : '$value ${S.current.months}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) _refreshData(value);
                            },
                          ),
                        ),

                        // Absolute/Percentage toggle
                        _buildToggleButton(),

                        // Radar chart with adaptive padding
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final horizontalPadding =
                                constraints.maxWidth * 0.05;
                            return SizedBox(
                              height: 320,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding, vertical: 30),
                                child: RadarChart(
                                  RadarChartData(
                                    radarBorderData: BorderSide(
                                        color: Theme.of(context).dividerColor),
                                    dataSets: [
                                      RadarDataSet(
                                        dataEntries: _getDataEntries(maxValue),
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.3),
                                        borderColor:
                                            Theme.of(context).primaryColor,
                                        borderWidth: 2,
                                      ),
                                    ],
                                    radarBackgroundColor: Colors.transparent,
                                    titleTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
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
                                    tickCount: 2,
                                    ticksTextStyle: const TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Summary cards responsive
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildSummaryCard(
                                  title: S.current.trainings,
                                  value: totalTrainings,
                                  icon: Icons.fitness_center),
                              _buildSummaryCard(
                                  title: S.current.exercises,
                                  value: totalExercises,
                                  icon: Icons.list_alt),
                              _buildSummaryCard(
                                  title: S.current.series,
                                  value: totalSets,
                                  icon: Icons.format_list_numbered),
                              _buildSummaryCard(
                                  title: S.current.reps_text,
                                  value: totalReps,
                                  icon: Icons.repeat),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }

  Future<void> _refreshData(int months) async {
    setState(() {
      selectedMonths = months;
      isLoading = true;
    });
    await _getTrainingData(availableExercises);
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _loadExercisesAndData() async {
    try {
      final exerciseList = await ExerciseMapper.fromJsonList();
      availableExercises = exerciseList;
      await _getTrainingData(exerciseList);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.current.error_loading_data)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _getTrainingData(List<Exercise> exercises) async {
    try {
      final List<TrainingHistory> trainingHistoryList =
          await FirestoreService().getTrainingHistoryData(selectedMonths);

      final Map<MuscularGroup, int> muscleGroupCounts = {
        for (var group in MuscularGroup.values) group: 0
      };
      int trainingCount = 0;
      int setsCount = 0;
      int exercisesCount = 0;
      int repsCount = 0;

      for (var traininHistory in trainingHistoryList) {
        trainingCount++;
        final customExercisesList = traininHistory.exercises;
        exercisesCount += customExercisesList.length;

        for (var customExercise in customExercisesList) {
          setsCount += customExercise.sets.length;
          repsCount += customExercise.sets.fold(0, (sum, set) => sum + set.reps);

          muscleGroupCounts[customExercise.exercise.muscularGroup] =
              (muscleGroupCounts[customExercise.exercise.muscularGroup] ?? 0) +
                  customExercise.sets.length;
        }
      }

      if (!mounted) return;

      setState(() {
        trainingCounts = muscleGroupCounts;
        totalTrainings = trainingCount;
        totalSets = setsCount;
        totalExercises = exercisesCount;
        totalReps = repsCount;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.current.error_loading_training_list)));
    }
  }

  Widget _buildToggleButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            setState(() => showAbsoluteValues = !showAbsoluteValues);
          },
          child: Text(showAbsoluteValues
              ? S.current.show_percentages
              : S.current.show_absolute_values),
        ),
      );

  Widget _buildSummaryCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return SizedBox(
      width: 160,
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
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<RadarEntry> _getDataEntries(int maxValue) {
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
