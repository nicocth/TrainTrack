// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register now`
  String get access_register {
    return Intl.message(
      'Register now',
      name: 'access_register',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get empty_password {
    return Intl.message(
      'Password is required',
      name: 'empty_password',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get user_not_found {
    return Intl.message(
      'User not found',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrong_password {
    return Intl.message(
      'Wrong password',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalid_email {
    return Intl.message(
      'Invalid email',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `User disabled`
  String get user_disabled {
    return Intl.message(
      'User disabled',
      name: 'user_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, user or password do not match`
  String get login_failed {
    return Intl.message(
      'Login failed, user or password do not match',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get fill_all_fields {
    return Intl.message(
      'Please fill all fields',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get app_bar_settings {
    return Intl.message(
      'Settings',
      name: 'app_bar_settings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Logout failed`
  String get logout_failed {
    return Intl.message(
      'Logout failed',
      name: 'logout_failed',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Statistics`
  String get statistics {
    return Intl.message('Statistics', name: 'statistics', desc: '', args: []);
  }

  /// `Preferences`
  String get preferences {
    return Intl.message('Preferences', name: 'preferences', desc: '', args: []);
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Mode`
  String get mode {
    return Intl.message('Mode', name: 'mode', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Error registering user`
  String get registration_failed {
    return Intl.message(
      'Error registering user',
      name: 'registration_failed',
      desc: '',
      args: [],
    );
  }

  /// `Email already in use`
  String get email_already_in_use {
    return Intl.message(
      'Email already in use',
      name: 'email_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get weak_password {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Create training`
  String get create_training {
    return Intl.message(
      'Create training',
      name: 'create_training',
      desc: '',
      args: [],
    );
  }

  /// `My trainings`
  String get my_trainings {
    return Intl.message(
      'My trainings',
      name: 'my_trainings',
      desc: '',
      args: [],
    );
  }

  /// `Uknown error`
  String get uknown_error {
    return Intl.message(
      'Uknown error',
      name: 'uknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Routine title`
  String get routine_title {
    return Intl.message(
      'Routine title',
      name: 'routine_title',
      desc: '',
      args: [],
    );
  }

  /// `Save routine`
  String get save_routine {
    return Intl.message(
      'Save routine',
      name: 'save_routine',
      desc: '',
      args: [],
    );
  }

  /// `Routine saved`
  String get routine_saved {
    return Intl.message(
      'Routine saved',
      name: 'routine_saved',
      desc: '',
      args: [],
    );
  }

  /// `Error saving routine`
  String get error_saving_routine {
    return Intl.message(
      'Error saving routine',
      name: 'error_saving_routine',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a title`
  String get empty_title {
    return Intl.message(
      'Please enter a title',
      name: 'empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least one exercise`
  String get empty_exercises_list {
    return Intl.message(
      'Please add at least one exercise',
      name: 'empty_exercises_list',
      desc: '',
      args: [],
    );
  }

  /// `Add exercise`
  String get add_exercise {
    return Intl.message(
      'Add exercise',
      name: 'add_exercise',
      desc: '',
      args: [],
    );
  }

  /// `Add series`
  String get add_series {
    return Intl.message('Add series', name: 'add_series', desc: '', args: []);
  }

  /// `Add selected`
  String get add_selected {
    return Intl.message(
      'Add selected',
      name: 'add_selected',
      desc: '',
      args: [],
    );
  }

  /// `Create routine`
  String get create_routine {
    return Intl.message(
      'Create routine',
      name: 'create_routine',
      desc: '',
      args: [],
    );
  }

  /// `Edit routine`
  String get edit_routine {
    return Intl.message(
      'Edit routine',
      name: 'edit_routine',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Series`
  String get series {
    return Intl.message('Series', name: 'series', desc: '', args: []);
  }

  /// `Kg`
  String get kg_text {
    return Intl.message('Kg', name: 'kg_text', desc: '', args: []);
  }

  /// `0.0`
  String get kg {
    return Intl.message('0.0', name: 'kg', desc: '', args: []);
  }

  /// `Reps`
  String get reps_text {
    return Intl.message('Reps', name: 'reps_text', desc: '', args: []);
  }

  /// `0`
  String get reps {
    return Intl.message('0', name: 'reps', desc: '', args: []);
  }

  /// `Wrong value. Please introduce a number.`
  String get number_value_error {
    return Intl.message(
      'Wrong value. Please introduce a number.',
      name: 'number_value_error',
      desc: '',
      args: [],
    );
  }

  /// `The request has taken too long, check your connection`
  String get request_timeout {
    return Intl.message(
      'The request has taken too long, check your connection',
      name: 'request_timeout',
      desc: '',
      args: [],
    );
  }

  /// `There are no saved workouts`
  String get empty_training_list {
    return Intl.message(
      'There are no saved workouts',
      name: 'empty_training_list',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load trainings list.`
  String get error_loading_training_list {
    return Intl.message(
      'Failed to load trainings list.',
      name: 'error_loading_training_list',
      desc: '',
      args: [],
    );
  }

  /// `Deletion confirmation`
  String get confirm_delete {
    return Intl.message(
      'Deletion confirmation',
      name: 'confirm_delete',
      desc: '',
      args: [],
    );
  }

  /// `Completion confirmation`
  String get confirm_finish_training {
    return Intl.message(
      'Completion confirmation',
      name: 'confirm_finish_training',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the training?`
  String get confirm_delete_message_training {
    return Intl.message(
      'Are you sure you want to delete the training?',
      name: 'confirm_delete_message_training',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the exercise?`
  String get confirm_delete_message_exercise {
    return Intl.message(
      'Are you sure you want to delete the exercise?',
      name: 'confirm_delete_message_exercise',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to finish the training?`
  String get confirm_finish_message_training {
    return Intl.message(
      'Are you sure you want to finish the training?',
      name: 'confirm_finish_message_training',
      desc: '',
      args: [],
    );
  }

  /// `Exercises`
  String get exercises {
    return Intl.message('Exercises', name: 'exercises', desc: '', args: []);
  }

  /// `Summary`
  String get summary {
    return Intl.message('Summary', name: 'summary', desc: '', args: []);
  }

  /// `Months`
  String get training_chat_x_title {
    return Intl.message(
      'Months',
      name: 'training_chat_x_title',
      desc: '',
      args: [],
    );
  }

  /// `Times performed`
  String get training_chat_y_title {
    return Intl.message(
      'Times performed',
      name: 'training_chat_y_title',
      desc: '',
      args: [],
    );
  }

  /// `Alternative number`
  String get hint_alternative_text {
    return Intl.message(
      'Alternative number',
      name: 'hint_alternative_text',
      desc: '',
      args: [],
    );
  }

  /// `Start training`
  String get start_training {
    return Intl.message(
      'Start training',
      name: 'start_training',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Select the next exercise:`
  String get select_exercise {
    return Intl.message(
      'Select the next exercise:',
      name: 'select_exercise',
      desc: '',
      args: [],
    );
  }

  /// `Finish exercise`
  String get finish_exercise {
    return Intl.message(
      'Finish exercise',
      name: 'finish_exercise',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
