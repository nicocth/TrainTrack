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

  /// `Nickname`
  String get nickname {
    return Intl.message('Nickname', name: 'nickname', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Current password`
  String get current_password {
    return Intl.message(
      'Current password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
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

  /// `Wrong current password`
  String get wrong_current_password {
    return Intl.message(
      'Wrong current password',
      name: 'wrong_current_password',
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

  /// `Current password is required`
  String get current_password_empty {
    return Intl.message(
      'Current password is required',
      name: 'current_password_empty',
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

  /// `Save training`
  String get save_training {
    return Intl.message(
      'Save training',
      name: 'save_training',
      desc: '',
      args: [],
    );
  }

  /// `Training saved`
  String get training_saved {
    return Intl.message(
      'Training saved',
      name: 'training_saved',
      desc: '',
      args: [],
    );
  }

  /// `Registered and updated training`
  String get training_updated_saved {
    return Intl.message(
      'Registered and updated training',
      name: 'training_updated_saved',
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

  /// `Are you sure you want to delete your account? All data associated with it will be deleted (trainings, history, etc...).`
  String get delete_account_confirm {
    return Intl.message(
      'Are you sure you want to delete your account? All data associated with it will be deleted (trainings, history, etc...).',
      name: 'delete_account_confirm',
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

  /// `Execution`
  String get exercise_setail_title {
    return Intl.message(
      'Execution',
      name: 'exercise_setail_title',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Commit changes`
  String get update_training_alert {
    return Intl.message(
      'Commit changes',
      name: 'update_training_alert',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to update the training with the current values?`
  String get update_training_message {
    return Intl.message(
      'Do you want to update the training with the current values?',
      name: 'update_training_message',
      desc: '',
      args: [],
    );
  }

  /// `Search exercise`
  String get search_exercise {
    return Intl.message(
      'Search exercise',
      name: 'search_exercise',
      desc: '',
      args: [],
    );
  }

  /// `Select a muscle group`
  String get select_muscular_group {
    return Intl.message(
      'Select a muscle group',
      name: 'select_muscular_group',
      desc: '',
      args: [],
    );
  }

  /// `All muscle groups`
  String get all_muscular_groups {
    return Intl.message(
      'All muscle groups',
      name: 'all_muscular_groups',
      desc: '',
      args: [],
    );
  }

  /// `Pectoral`
  String get pectoral {
    return Intl.message('Pectoral', name: 'pectoral', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Biceps`
  String get biceps {
    return Intl.message('Biceps', name: 'biceps', desc: '', args: []);
  }

  /// `Triceps`
  String get triceps {
    return Intl.message('Triceps', name: 'triceps', desc: '', args: []);
  }

  /// `Abdomen`
  String get abdomen {
    return Intl.message('Abdomen', name: 'abdomen', desc: '', args: []);
  }

  /// `Shoulders`
  String get shoulders {
    return Intl.message('Shoulders', name: 'shoulders', desc: '', args: []);
  }

  /// `Legs`
  String get legs {
    return Intl.message('Legs', name: 'legs', desc: '', args: []);
  }

  /// `Update nickname`
  String get update_nickname {
    return Intl.message(
      'Update nickname',
      name: 'update_nickname',
      desc: '',
      args: [],
    );
  }

  /// `Update password`
  String get update_password {
    return Intl.message(
      'Update password',
      name: 'update_password',
      desc: '',
      args: [],
    );
  }

  /// `Nickname updated`
  String get nickname_updated {
    return Intl.message(
      'Nickname updated',
      name: 'nickname_updated',
      desc: '',
      args: [],
    );
  }

  /// `Password updated`
  String get password_updated {
    return Intl.message(
      'Password updated',
      name: 'password_updated',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted`
  String get account_deleted {
    return Intl.message(
      'Account deleted',
      name: 'account_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get edit_profile {
    return Intl.message(
      'Edit profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get stadistics {
    return Intl.message('Statistics', name: 'stadistics', desc: '', args: []);
  }

  /// `Error loading data`
  String get error_loading_data {
    return Intl.message(
      'Error loading data',
      name: 'error_loading_data',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Months`
  String get months {
    return Intl.message('Months', name: 'months', desc: '', args: []);
  }

  /// `Show percentages`
  String get show_percentages {
    return Intl.message(
      'Show percentages',
      name: 'show_percentages',
      desc: '',
      args: [],
    );
  }

  /// `Show absolute values`
  String get show_absolute_values {
    return Intl.message(
      'Show absolute values',
      name: 'show_absolute_values',
      desc: '',
      args: [],
    );
  }

  /// `trainings`
  String get trainings {
    return Intl.message('trainings', name: 'trainings', desc: '', args: []);
  }

  /// `sets`
  String get sets {
    return Intl.message('sets', name: 'sets', desc: '', args: []);
  }

  /// `Usage guide`
  String get usage_guide {
    return Intl.message('Usage guide', name: 'usage_guide', desc: '', args: []);
  }

  /// `Main screen:`
  String get home_title {
    return Intl.message('Main screen:', name: 'home_title', desc: '', args: []);
  }

  /// `Displays a list of custom workouts if there are any, but instead displays a message inviting you to create your first workout. If you can't retrieve them, you'll be informed that you're offline. If they display correctly, you'll be able to edit, delete, or start them. <br><br>Gives the option to create a new workout. <br><br>Gives the option to navigate to the Settings screen.`
  String get home_description {
    return Intl.message(
      'Displays a list of custom workouts if there are any, but instead displays a message inviting you to create your first workout. If you can\'t retrieve them, you\'ll be informed that you\'re offline. If they display correctly, you\'ll be able to edit, delete, or start them. <br><br>Gives the option to create a new workout. <br><br>Gives the option to navigate to the Settings screen.',
      name: 'home_description',
      desc: '',
      args: [],
    );
  }

  /// `Create training:`
  String get create_training_title {
    return Intl.message(
      'Create training:',
      name: 'create_training_title',
      desc: '',
      args: [],
    );
  }

  /// `The title of the routine is mandatory, as is having at least one exercise; otherwise, an error will occur when saving.<br><br>When you click the add exercise button, you will go to the add exercises screen.`
  String get create_training_description_1 {
    return Intl.message(
      'The title of the routine is mandatory, as is having at least one exercise; otherwise, an error will occur when saving.<br><br>When you click the add exercise button, you will go to the add exercises screen.',
      name: 'create_training_description_1',
      desc: '',
      args: [],
    );
  }

  /// `Add exercise:`
  String get add_exercise_title {
    return Intl.message(
      'Add exercise:',
      name: 'add_exercise_title',
      desc: '',
      args: [],
    );
  }

  /// `Select exercises from a large library, which will have filters by category and a search engine to make the task easier. <br><br> You can also click on the image of the exercises to zoom in and get an idea of ​​what the exercise is like.<br><br> By clicking on add selected we will return to the create training screen`
  String get add_exercise_description {
    return Intl.message(
      'Select exercises from a large library, which will have filters by category and a search engine to make the task easier. <br><br> You can also click on the image of the exercises to zoom in and get an idea of ​​what the exercise is like.<br><br> By clicking on add selected we will return to the create training screen',
      name: 'add_exercise_description',
      desc: '',
      args: [],
    );
  }

  /// `The following parameters are defined for each of the selected exercises:<br><br> - Notes<br> - Sets<br> - Repetitions<br> - Weights<br><br>If the alternative option is enabled in two exercises and the number that appears is equal (if it is not modified it will be 0) it will later appear in the diagrams at the same level.<br><br>The user saves the created workout and returns to the main menu. If you are offline and more than 6 seconds pass, you are informed to check your connection and it will not advance to the main menu so as not to lose the created routine. <br><br>If you click on the title, a window will appear that will show you how to execute them correctly.`
  String get create_training_description_2 {
    return Intl.message(
      'The following parameters are defined for each of the selected exercises:<br><br> - Notes<br> - Sets<br> - Repetitions<br> - Weights<br><br>If the alternative option is enabled in two exercises and the number that appears is equal (if it is not modified it will be 0) it will later appear in the diagrams at the same level.<br><br>The user saves the created workout and returns to the main menu. If you are offline and more than 6 seconds pass, you are informed to check your connection and it will not advance to the main menu so as not to lose the created routine. <br><br>If you click on the title, a window will appear that will show you how to execute them correctly.',
      name: 'create_training_description_2',
      desc: '',
      args: [],
    );
  }

  /// `If training is chosen in the Main Menu (Summary Screen)`
  String get summary_title {
    return Intl.message(
      'If training is chosen in the Main Menu (Summary Screen)',
      name: 'summary_title',
      desc: '',
      args: [],
    );
  }

  /// `Shows a summary that will begin with a graph that will show you how many times you have performed that workout in the last 3 months, this will help you choose the muscle group or routine before starting the training session. <br><br>Shows a diagram that allows us to see the exercises and their order. <br><br>If we are convinced, we will click start and advance to the next screen.`
  String get summary_description {
    return Intl.message(
      'Shows a summary that will begin with a graph that will show you how many times you have performed that workout in the last 3 months, this will help you choose the muscle group or routine before starting the training session. <br><br>Shows a diagram that allows us to see the exercises and their order. <br><br>If we are convinced, we will click start and advance to the next screen.',
      name: 'summary_description',
      desc: '',
      args: [],
    );
  }

  /// `Exercise Selection Screen:`
  String get exercise_selection_title {
    return Intl.message(
      'Exercise Selection Screen:',
      name: 'exercise_selection_title',
      desc: '',
      args: [],
    );
  }

  /// `Gives the option to end the workout.<br><br>Shows the time we have been training, this helps to control the execution and rest times during the workout.<br><br>Shows a diagram of our exercises with a selection box, which allows us to select the exercise we want to execute, this fixes problems such as busy machines, momentary lack of equipment and allows us to alter the order of the workout without wasting time, since the predefined routines that force you to follow a specific order (the order being important for our training) are not very versatile and would make us waste too much time waiting for busy machines.<br><br>If we select an exercise we go to the next window.`
  String get exercise_selection_description {
    return Intl.message(
      'Gives the option to end the workout.<br><br>Shows the time we have been training, this helps to control the execution and rest times during the workout.<br><br>Shows a diagram of our exercises with a selection box, which allows us to select the exercise we want to execute, this fixes problems such as busy machines, momentary lack of equipment and allows us to alter the order of the workout without wasting time, since the predefined routines that force you to follow a specific order (the order being important for our training) are not very versatile and would make us waste too much time waiting for busy machines.<br><br>If we select an exercise we go to the next window.',
      name: 'exercise_selection_description',
      desc: '',
      args: [],
    );
  }

  /// `Training screen:`
  String get training_screen_title {
    return Intl.message(
      'Training screen:',
      name: 'training_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Allows you to view the image and description of the exercise.<br><br>Allows you to modify sets, repetitions and weights<br><br>After completing each set the user will have to mark it as done, and clicking that they have finished the exercise will return them to the training diagram in which the exercise check will have been marked and they will be able to choose the next exercise.`
  String get training_screen_description {
    return Intl.message(
      'Allows you to view the image and description of the exercise.<br><br>Allows you to modify sets, repetitions and weights<br><br>After completing each set the user will have to mark it as done, and clicking that they have finished the exercise will return them to the training diagram in which the exercise check will have been marked and they will be able to choose the next exercise.',
      name: 'training_screen_description',
      desc: '',
      args: [],
    );
  }

  /// `Statistics screen:`
  String get statistics_screen_title {
    return Intl.message(
      'Statistics screen:',
      name: 'statistics_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `All data displayed is filtered by the month range which includes 1, 3, 6 and 12 months.<br><br>The toggle button allows you to toggle the radar chart data from absolute values ​​to percentages.<br><br>The radar chart shows the proportion of exercises per muscle group to observe imbalances.<br><br>The cards below show total values ​​in the date range.`
  String get statistics_screen_description {
    return Intl.message(
      'All data displayed is filtered by the month range which includes 1, 3, 6 and 12 months.<br><br>The toggle button allows you to toggle the radar chart data from absolute values ​​to percentages.<br><br>The radar chart shows the proportion of exercises per muscle group to observe imbalances.<br><br>The cards below show total values ​​in the date range.',
      name: 'statistics_screen_description',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile data screen`
  String get edit_profile_screen_title {
    return Intl.message(
      'Edit profile data screen',
      name: 'edit_profile_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Allows you to modify the user name but not their email.<br><br>To modify the password or delete the account, the current password will be required. If you do not enter it or it is incorrect, an error message will be displayed.<br><br>To delete the account, it will ask for confirmation and warn you of the loss of data that this entails.`
  String get edit_profile_screen_description {
    return Intl.message(
      'Allows you to modify the user name but not their email.<br><br>To modify the password or delete the account, the current password will be required. If you do not enter it or it is incorrect, an error message will be displayed.<br><br>To delete the account, it will ask for confirmation and warn you of the loss of data that this entails.',
      name: 'edit_profile_screen_description',
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
