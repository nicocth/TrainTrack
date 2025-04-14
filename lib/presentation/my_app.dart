
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:train_track/config/theme/app_theme.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/presentation/screens/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/presentation/screens/auth/login_screen.dart';
import 'package:train_track/infraestructure/auth_firebase/auth_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return GestureDetector(
      onTap: () {
        // Close the keyboard anywhere in the app when tapped outside the text field
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Train Track',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('es'), // Spanish
          Locale('en'), // English
        ],
        // Check if the user is authenticated to show the correct screen
        home: authState == null ? const LoginScreen() :  const HomeScreen(),
      ),
    );
  }
}
