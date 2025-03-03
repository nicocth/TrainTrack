import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/providers/trainings_provider.dart';
import 'package:train_track/presentation/screens/create_training/create_training_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Se asegura de escuchar cuando regresa a esta pantalla y refrescar la lista
    Future.microtask(() => ref.refresh(trainingsProvider));
  }

  @override
  Widget build(BuildContext context) {
    final trainings = ref.watch(trainingsProvider);

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
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTrainingScreen(),
                ),
              );
              // Refrescar la lista de entrenamientos cuando regresa
              ref.invalidate(trainingsProvider);
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
            child: trainings.when(
              data: (trainingsList) => trainingsList.isEmpty
                  ? Center(child: Text(S.current.empty_exercises_list))
                  : ListView.builder(
                      itemCount: trainingsList.length,
                      itemBuilder: (context, index) {
                        final training = trainingsList[index];

                        // Find the image with order == 0
                        final customExerciseImage = training.exercises
                            .firstWhere(
                              (exercise) => exercise.order == 0,
                              orElse: () => training.exercises.first,
                            )
                            .exercise
                            .image;

return Card(
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
        // Imagen de fondo
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              customExerciseImage,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Capa de opacidad (oscurecer imagen)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ),
        ),

        // Texto del entrenamiento
        Padding(
          padding: const EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              training.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
            ),
          ),
        ),
      ],
    ),
  ),
);

                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text(S.current.error_loading_training_list)),
            ),
          )
        ],
      ),
    );
  }
}
