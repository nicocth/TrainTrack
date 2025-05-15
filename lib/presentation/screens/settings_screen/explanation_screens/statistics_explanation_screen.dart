import 'package:flutter/material.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

class StatisticsExplanationScreen extends StatelessWidget {
  const StatisticsExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(S.current.usage_guide)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Explanation of statistics screen
                Text(
                  S.current.statistics_screen_title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("assets/images/statistics_screen.jpg"),
                  ),
                ),
                const SizedBox(height: 10),
                Html(data: S.current.statistics_screen_description),
                const SizedBox(height: 10),
                // Explanation of statistics screen
                Text(
                  S.current.history_screen_title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("assets/images/history_screen.jpg"),
                  ),
                ),
                const SizedBox(height: 10),
                Html(data: S.current.history_screen_description),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const TrainingSessionBanner(),
      ),
    );
  }
}
