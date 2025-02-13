// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Hello ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "access_register": MessageLookupByLibrary.simpleMessage("Register now"),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "app_bar_settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Confirm password",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_already_in_use": MessageLookupByLibrary.simpleMessage(
      "Email already in use",
    ),
    "helloToUser": m0,
    "help": MessageLookupByLibrary.simpleMessage("Help"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "invalid_email": MessageLookupByLibrary.simpleMessage("Invalid email"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_failed": MessageLookupByLibrary.simpleMessage(
      "Login failed, user or password do not match",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logout_failed": MessageLookupByLibrary.simpleMessage("Logout failed"),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwords_do_not_match": MessageLookupByLibrary.simpleMessage(
      "passwords do not match",
    ),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registration_failed": MessageLookupByLibrary.simpleMessage(
      "Error registering user",
    ),
    "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
    "user_disabled": MessageLookupByLibrary.simpleMessage("User disabled"),
    "user_not_found": MessageLookupByLibrary.simpleMessage("User not found"),
    "weak_password": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "wrong_password": MessageLookupByLibrary.simpleMessage("Wrong password"),
  };
}
