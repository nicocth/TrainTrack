// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(name) => "Hola ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "access_register": MessageLookupByLibrary.simpleMessage(
      "¿Aún no tienes una cuenta?",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
    "app_bar_settings": MessageLookupByLibrary.simpleMessage("Configuración"),
    "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "helloToUser": m0,
    "help": MessageLookupByLibrary.simpleMessage("Ayuda"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "invalid_email": MessageLookupByLibrary.simpleMessage(
      "Correo electrónico inválido",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Idioma"),
    "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "login_failed": MessageLookupByLibrary.simpleMessage(
      "Error al iniciar sesión, el usuario o la contraseña no coinciden",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "logout_failed": MessageLookupByLibrary.simpleMessage(
      "Error al cerrar sesión",
    ),
    "mode": MessageLookupByLibrary.simpleMessage("Modo"),
    "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferencias"),
    "statistics": MessageLookupByLibrary.simpleMessage("Estadisticas"),
    "user_disabled": MessageLookupByLibrary.simpleMessage(
      "Usuario deshabilitado",
    ),
    "user_not_found": MessageLookupByLibrary.simpleMessage(
      "Usuario no encontrado",
    ),
    "wrong_password": MessageLookupByLibrary.simpleMessage(
      "Contraseña incorrecta",
    ),
  };
}
