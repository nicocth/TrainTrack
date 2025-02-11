
import 'package:flutter/material.dart';
import 'package:train_track/config/theme/app_theme.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);




    return MaterialApp(
      title: 'TrainTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      home: authState == null ? const LoginScreen() :  const HomeScreen(),
    );
  }
}
