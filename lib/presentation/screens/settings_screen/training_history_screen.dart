import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:train_track/domain/models/training_history.dart';
import 'package:train_track/generated/l10n.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/widgets/shared/training_history_bottom_sheet.dart';
import 'package:train_track/presentation/widgets/shared/training_session_banner.dart';

// Provider to upload the training history list
final trainingHistoryProvider =
    FutureProvider<List<TrainingHistory>>((ref) async {
  final FirestoreService firestoreService = FirestoreService();

  final result = await firestoreService
      .getTrainingHistoryData(12)
      .timeout(Duration(seconds: 4), onTimeout: () {
    throw TimeoutException(S.current.request_timeout); // Handle timeout error
  });
  return result;
});

class TrainingHistoryScreen extends ConsumerWidget {
  const TrainingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingHistoryAsync = ref.watch(trainingHistoryProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.history),
        ),
        body: trainingHistoryAsync.when(
          data: (historyList) {
            if (historyList.isEmpty) {
              return Center(child: Text(S.current.empty_history));
            }
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];
                final formattedDate =
                    DateFormat('dd/MM/yyyy').format(history.trainingDate);
                return ListTile(
                  title: Text(history.name),
                  subtitle: Text(formattedDate),
                  leading: const Icon(Icons.fitness_center),
                  trailing: const Icon(Icons.arrow_downward, size: 16),
                  onTap: () {
                    showBottomSheetHistory(context, history);
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) {
            String message = S.current.request_timeout;

            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  message,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: const TrainingSessionBanner(),
      ),
    );
  }

  Future<dynamic> showBottomSheetHistory(
      BuildContext context, TrainingHistory history) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TrainingHistoryBottomSheet(history: history),
    );
  }
}
