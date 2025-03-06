import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/trainings_provider.dart';
import 'package:train_track/presentation/screens/create_training/create_training_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';
import 'package:train_track/presentation/widgets/shared/training_card.dart';

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

                              return TrainingCard(training: training);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}