import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/create_training/create_training_screen.dart';
import 'package:train_track/presentation/screens/settings_screen/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final trainings = ref.watch(trainingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.home),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            }     
          )
        ],
      ),
      body:  Column(
        children: [
          ListTile(
            title: Text(S.current.create_training),
            trailing: const Icon(Icons.add),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTrainingScreen()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(S.current.my_trainings, style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          Expanded(
            child: Text("Lista de entrenamientos"),
            // TODO: Implementar la lista de entrenamientos
            // trainings.when(
            //   data: (trainingsList) => trainingsList.isEmpty
            //       ? const Center(child: Text('No hay entrenamientos disponibles'))
            //       : ListView.builder(
            //           itemCount: trainingsList.length,
            //           itemBuilder: (context, index) {
            //             final training = trainingsList[index];
            //             return ListTile(
            //               title: Text(training.name),
            //               subtitle: Text(training.date),
            //               onTap: () {
            //                 // Acción al seleccionar un entrenamiento
            //               },
            //             );
            //           },
            //         ),
            //   loading: () => const Center(child: CircularProgressIndicator()),
            //   error: (error, _) => Center(child: Text('Error: $error')),
            // ),
          ),
        ],
      ),
    );
  }
}
