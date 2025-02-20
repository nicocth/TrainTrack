import 'package:flutter/material.dart';
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

  Future<void> loadExerciseFromJson() async {
  List<Ejercicio> exerciseList = await EjercicioMapper.fromJsonList(); 
  setState(() {
    availableExercises = exerciseList;
  });
  }

  @override
  void initState() {
    super.initState();
    loadExerciseFromJson();
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
    child: ListTile(
      title: SizedBox(height: 60, child: Text(exercise.nombre)),
      leading: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Opcional: redondear la imagen en el zoom
                child: Image.asset(
                  exercise.imagen,
                  fit: BoxFit.contain, // Asegurar que la imagen se vea bien
                ),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100), // Redondear imagen
          child: Image.asset(
            exercise.imagen,
            width: 60,
            height: 100,
            fit: BoxFit.cover,
          ),
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
