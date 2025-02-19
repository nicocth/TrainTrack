import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/ejercicio.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/mappers/ejercicio_mapper.dart';
import 'package:train_track/presentation/providers/create_training_provider.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final Set<Ejercicio> selectedExercises = {};
  List<Ejercicio> availableExercises = [];

  Future<void> cargarEjerciciosDesdeJson() async {
  final String jsonString = await rootBundle.loadString('lib/shared/data/exercise.json');
  setState(() {
    availableExercises = EjercicioMapper.fromJsonList(jsonString);
  });
  }

  @override
  void initState() {
    super.initState();
    cargarEjerciciosDesdeJson();
  }

  @override
  Widget build(BuildContext context) {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(S.current.add_exercise)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: availableExercises.length,
              itemBuilder: (context, index) {
                final exercise = availableExercises[index];
                final isSelected = selectedExercises.contains(exercise);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0), // Espaciado entre elementos
                  child: Center(
                    child: ListTile( // Espaciado interno
                      title: SizedBox(height: 60, child: Text(exercise.nombre), ),
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100), // Redondear imagen
                          child: Image.asset(
                            exercise.imagen,
                            width: 60, 
                            height: 100,
                            fit: BoxFit.contain, // Asegurar que la imagen se ajuste
                          ),
                        ),                         
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? Colors.green : null,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedExercises.remove(exercise);
                          } else {
                            selectedExercises.add(exercise);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),

          ),
          // Botón para agregar ejercicios seleccionados
          Padding(
            padding: const EdgeInsets.all(20.0),
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
}
