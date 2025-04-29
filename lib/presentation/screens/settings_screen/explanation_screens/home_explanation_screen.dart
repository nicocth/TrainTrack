import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class HomeExplanationScreen extends StatelessWidget {
  const HomeExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.usage_guide)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Explanation of Home screen
              Html(data: S.current.home_description),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/home.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TrainingSessionBanner(),
    );
  }
}
