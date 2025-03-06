import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';

class TrainingChart extends ConsumerWidget {
  const TrainingChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // X Axis Title
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            S.current.training_chat_x_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rotate Y Axis Title
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                S.current.training_chat_y_title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            Expanded(
              child: SizedBox(
                height: 130,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 8,
                    barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 5, color: Colors.blue, width: 16),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 8, color: Colors.green, width: 16),
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 3, color: Colors.red, width: 16),
                      ]),
                    ],
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            switch (value.toInt()) {
                              case 1:
                                return const Text("Ene");
                              case 2:
                                return const Text("Feb");
                              case 3:
                                return const Text("Mar");
                              default:
                                return const Text("");
                            }
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
  }
}
