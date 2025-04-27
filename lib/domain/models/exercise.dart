import 'dart:io';

import 'package:flutter/material.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String image;
  final bool isLocal;
  final MuscularGroup muscularGroup;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.muscularGroup,
    this.isLocal = false,
  });

  // Method to get the appropriate ImageProvider
  ImageProvider get imageProvider {
    return isLocal ? FileImage(File(image)) : AssetImage(image);
  }

  // Method copyWith for modifying the object
  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    bool? isLocal,
    MuscularGroup? muscularGroup,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      isLocal: isLocal ?? this.isLocal,
      muscularGroup: muscularGroup ?? this.muscularGroup,
    );
  }
}