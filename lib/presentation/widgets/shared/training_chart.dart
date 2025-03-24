import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:intl/intl.dart';

class TrainingChart extends ConsumerWidget {
  final Training training;
  const TrainingChart({super.key, required this.training});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<int>>( // Asynchronously fetch training count for the last three months
      future: _getTrainingCount(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
        }
        final trainingCount = snapshot.data ?? [0, 0, 0]; // Default values in case of error or empty data
        final lastThreeMonths = _getLastThreeMonths(); // Get labels for the last three months

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                S.current.training_chat_x_title, // X-axis title
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    S.current.training_chat_y_title, // Y-axis title
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 130,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 8, // Maximum value on the Y-axis
                        barGroups: List.generate(3, (index) {
                          return BarChartGroupData(
                            x: index + 1,
                            barRods: [
                              BarChartRodData(
                                toY: trainingCount[index].toDouble(), // Training count value
                                color: Colors.orange[800],
                                width: 16,
                              ),
                            ],
                          );
                        }),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Hide left Y-axis labels
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                int index = value.toInt() - 1;
                                if (index >= 0 && index < 3) {
                                  return Text(lastThreeMonths[index]); // Month labels on X-axis
                                }
                                return const Text("");
                              },
                              reservedSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<List<int>> _getTrainingCount(WidgetRef ref) async {
    final FirestoreService firestoreService = FirestoreService();
    try {
      final result = await firestoreService
          .getTrainingCountLastThreeMonths(ref, training.name)
          .timeout(Duration(seconds: 4), onTimeout: () {
        throw TimeoutException(S.current.request_timeout); // Handle timeout error
      });
      return result;
    } catch (e) {
      return [0, 0, 0]; // Return default values in case of an error
    }
  }

  List<String> _getLastThreeMonths() {
    DateTime now = DateTime.now();
    return List.generate(3, (index) {
      DateTime month = DateTime(now.year, now.month - (2 - index));
      return DateFormat.MMM().format(month); // Get abbreviated month names
    });
  }
}