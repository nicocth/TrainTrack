import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:train_track/presentation/my_app.dart';
import 'config/firebase/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}


