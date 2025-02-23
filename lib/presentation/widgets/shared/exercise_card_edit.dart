// Tarjeta personalizada para cada ejercicio
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';

class ExerciseCard extends StatefulWidget {
  final dynamic exercise;
  final VoidCallback onDelete;

  const ExerciseCard({Key? key, required this.exercise, required this.onDelete}) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>> series = []; // Lista de series (KG y reps)

  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Sección superior con imagen, nombre y menú de opciones
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Opcional: redondear la imagen en el zoom
                          child: Image.asset(
                            widget.exercise.imagen,
                            fit: BoxFit.contain, // Asegurar que la imagen se vea bien
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100), // Redondear imagen
                    child: Image.asset(
                      widget.exercise.imagen,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.exercise.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    widget.onDelete();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 10),

            // Campo de notas
            SizedBox(
              height:50,
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: S.current.notes,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado de la tabla
                Row(
                  children: [
                    SizedBox(width: 50, child: Center(child: Text(S.current.series, style: TextStyle(fontWeight: FontWeight.bold)))),
                    SizedBox(width: 50),
                    SizedBox(width: 50, child: Center(child: Text(S.current.kg, style: TextStyle(fontWeight: FontWeight.bold)))),
                    SizedBox(width: 50),
                    SizedBox(width: 50, child: Center(child: Text(S.current.reps, style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
                const SizedBox(height: 5),
                // Lista de series
                Column(
                  children: List.generate(series.length, (index) {
                    return Row(
                      children: [
                        SizedBox(width: 50, child: Center(child: Text("${index + 1}"))), // Número de serie
                        const SizedBox(width: 50),
                        SizedBox(// field for kg
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              series[index]['kg'] = double.tryParse(value) ?? 0;
                            },
                            decoration: InputDecoration(hintText: S.current.kg),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 50), // spacer
                        SizedBox(// field for reps
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              series[index]['reps'] = int.tryParse(value) ?? 0;
                            },
                            decoration: InputDecoration(hintText: S.current.reps),
                            textAlign: TextAlign.center,
                          ),
                        ), 
                        SizedBox(width: 5), // spacer
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              series.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),

            // Botón para agregar series
            TextButton.icon(
              onPressed: () {
                setState(() {
                  series.add({'kg': 0.0, 'reps': 0});
                });
              },
              icon: const Icon(Icons.add),
              label: Text(S.current.add_series),
            ),
          ],
        ),
      ),
    );
  }
}
