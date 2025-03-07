import 'package:flutter/services.dart';

class IntegerTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permitir solo números enteros
    final regex = RegExp(r'^\d*$');

    if (regex.hasMatch(newValue.text)) {
      return newValue; // Acepta el valor ingresado si es válido
    } else {
      return oldValue; // Descarta la entrada inválida
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permitir solo números y un único punto decimal
    final regex = RegExp(r'^\d*\.?\d*$');

    if (regex.hasMatch(newValue.text)) {
      return newValue; // Acepta el valor ingresado si es válido
    } else {
      return oldValue; // Descarta la entrada inválida
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