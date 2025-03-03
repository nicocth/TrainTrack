import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:train_track/domain/models/training.dart';
import 'package:train_track/infraestructure/firestore/services/firestore_services.dart';
import 'package:train_track/presentation/providers/auth_provider.dart';

final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final authNotifier = ref.read(authProvider.notifier);
  final userId = authNotifier.getUserId();
  final firestoreService = FirestoreService();

  return await firestoreService.getAllTrainings(userId);
});
