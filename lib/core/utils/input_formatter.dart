import 'package:flutter/services.dart';
import 'package:train_track/domain/models/enum/muscular_group.dart';
import 'package:train_track/generated/l10n.dart';

class IntegerTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only integers
    final regex = RegExp(r'^\d*$');

    if (regex.hasMatch(newValue.text)) {
      return newValue; 
    } else {
      return oldValue; 
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only numbers and a single decimal point
    final regex = RegExp(r'^\d*\.?\d*$');

    if (regex.hasMatch(newValue.text)) {
      return newValue; 
    } else {
      return oldValue; 
    }
  }
}

class TimeFormatter {
  static String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

// custom class to translate the contents of MuscularGroup
class MuscularGroupFormatter {
  static String translate(MuscularGroup group) {
    switch (group) {
      case MuscularGroup.pectoral:
        return S.current.pectoral;
      case MuscularGroup.back:
        return S.current.back;
      case MuscularGroup.biceps:
        return S.current.biceps;
      case MuscularGroup.triceps:
        return S.current.triceps;
      case MuscularGroup.abdomen:
        return S.current.abdomen;
      case MuscularGroup.shoulders:
        return S.current.shoulders;
      case MuscularGroup.legs:
        return S.current.legs;
    }
  }
}