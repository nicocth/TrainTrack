import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/create_training/create_training_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';
import 'package:train_track/presentation/widgets/shared/training_chart.dart';

class TrainingSummaryScreen extends ConsumerWidget {
  final Training training;
  const TrainingSummaryScreen({required this.training, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.summary),
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
          // Routine name 
          Container( 
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(training.name, style: Theme.of(context).textTheme.headlineSmall)
          ),

          // TODO: add navigation statistics_screen and correct graphic data
          // Chart
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TrainingChart(),
          ),

          // Exercise list title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.exercises,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // Trainings list
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExerciseBox("Press banca"),
            ArrowDown(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExerciseBox("Press inclinado"),
                SizedBox(width: 16),
                ExerciseBox("Press inclinado (Máquina)"),
              ],
            ),
            ArrowDown(),
            ExerciseBox("Aperturas pecho (Máquina)"),
            ArrowDown(),
            ExerciseBox("Pullover con mancuernas"),
          ],
        ),
      ),
        ],
      ),
    );
  }
}


  Widget ArrowDown() {
    return Icon(Icons.arrow_downward, color: Colors.white, size: 30);
  }

  Widget ExerciseBox(String name) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[300],
            radius: 10,
          ),
          SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 8),
          Checkbox(value: true, onChanged: (value) {}),
        ],
      ),
    );
  }