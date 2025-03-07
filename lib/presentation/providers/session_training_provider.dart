import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionTrainingState {
  final int seconds;
  final bool isRunning;
  SessionTrainingState({required this.seconds, this.isRunning = false});
}

class SessionTrainingNotifier extends StateNotifier<SessionTrainingState> {
  Timer? _timer;
  int _elapsedTime = 0;

  SessionTrainingNotifier() : super(SessionTrainingState(seconds: 0));

  void startTimer() {
    if (state.isRunning) return;

    state = SessionTrainingState(seconds: _elapsedTime, isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime++;
      state = SessionTrainingState(seconds: _elapsedTime, isRunning: true);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = SessionTrainingState(seconds: _elapsedTime, isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    _elapsedTime = 0;
    state = SessionTrainingState(seconds: _elapsedTime, isRunning: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final sessionTrainingProvider =
    StateNotifierProvider<SessionTrainingNotifier, SessionTrainingState>(
        (ref) => SessionTrainingNotifier());
