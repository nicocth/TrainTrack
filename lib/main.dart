import 'package:flutter/material.dart';
import 'package:train_track/config/theme/app_theme.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrainTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      home: const HomeScreen(title: 'TrainTrack'),
    );
  }
}


