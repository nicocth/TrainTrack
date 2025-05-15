import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:train_track/core/utils/input_formatter.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';
import 'package:train_track/infraestructure/mappers/exercise_mapper.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

import '../../../generated/l10n.dart';

class AddLocalExercise extends StatefulWidget {
  final Map<String, dynamic>? exerciseToEdit;
  final int? exerciseIndex;

  const AddLocalExercise({
    super.key,
    this.exerciseToEdit,
    this.exerciseIndex,
  });

  @override
  State<AddLocalExercise> createState() => _AddLocalExerciseState();
}

class _AddLocalExerciseState extends State<AddLocalExercise> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  MuscularGroup? _selectedGroup;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(S.current.add_exercise)),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                //
                // Warning Button
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.amber),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () => _showStorageWarning(context),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        S.current.storage_warning_short,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                TextFormField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: S.current.exercise_name),
                  validator: (value) =>
                      value!.isEmpty ? S.current.required_field : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: S.current.exercise_setail_title),
                  minLines: 1,
                  maxLines: 6,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<MuscularGroup>(
                  value: _selectedGroup,
                  onChanged: (MuscularGroup? group) {
                    setState(() {
                      _selectedGroup = group;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(S.current.select_muscular_group),
                    ),
                    ...MuscularGroup.values.map((MuscularGroup group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(MuscularGroupFormatter.translate(group)),
                      );
                    }),
                  ],
                  validator: (value) =>
                      value == null ? S.current.select_muscular_group : null,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(S.current.select_image),
                ),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.file(_imageFile!, height: 100),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _saveExercise(context);
                  },
                  child: Text(S.current.save_exercise),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const TrainingSessionBanner(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.exerciseToEdit != null) {
      _nameController.text = widget.exerciseToEdit!['name'];
      _descriptionController.text = widget.exerciseToEdit!['description'];
      _selectedGroup = MuscularGroup.values.firstWhere(
        (e) => e.name == widget.exerciseToEdit!['muscular_group'],
      );
      _imageFile = File(widget.exerciseToEdit!['image']);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<void> _saveExercise(BuildContext context) async {
    if (!_formKey.currentState!.validate() || _selectedGroup == null) {
      return;
    }

    if (_imageFile == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.current.image_required),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newExercise = {
      'id': _nameController.text,
      'name': _nameController.text,
      'description': _descriptionController.text,
      'muscular_group': _selectedGroup!.name,
      'image': _imageFile!.path,
    };

    ExerciseMapper.saveLocalExercise(newExercise, widget.exerciseIndex);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.current.exercise_saved)),
    );

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }

  void _showStorageWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text(S.current.warning),
          ],
        ),
        content: Text(S.current.storage_warning_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.current.understood),
          ),
        ],
      ),
    );
  }
}
