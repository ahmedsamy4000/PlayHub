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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Player`
  String get Player {
    return Intl.message(
      'Player',
      name: 'Player',
      desc: '',
      args: [],
    );
  }

  /// `Trainer`
  String get Trainer {
    return Intl.message(
      'Trainer',
      name: 'Trainer',
      desc: '',
      args: [],
    );
  }

  /// `Playground Owner`
  String get Owner {
    return Intl.message(
      'Playground Owner',
      name: 'Owner',
      desc: '',
      args: [],
    );
  }

  /// `Edit Information`
  String get pop1 {
    return Intl.message(
      'Edit Information',
      name: 'pop1',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get pop2 {
    return Intl.message(
      'Change Password',
      name: 'pop2',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get pop3 {
    return Intl.message(
      'Logout',
      name: 'pop3',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get pop4 {
    return Intl.message(
      'Delete Account',
      name: 'pop4',
      desc: '',
      args: [],
    );
  }

  /// `Football`
  String get Football {
    return Intl.message(
      'Football',
      name: 'Football',
      desc: '',
      args: [],
    );
  }

  /// `Volleyball`
  String get Volleyball {
    return Intl.message(
      'Volleyball',
      name: 'Volleyball',
      desc: '',
      args: [],
    );
  }

  /// `Basketball`
  String get Basketball {
    return Intl.message(
      'Basketball',
      name: 'Basketball',
      desc: '',
      args: [],
    );
  }

  /// `Tennis`
  String get Tennis {
    return Intl.message(
      'Tennis',
      name: 'Tennis',
      desc: '',
      args: [],
    );
  }

  /// `Workout`
  String get Workout {
    return Intl.message(
      'Workout',
      name: 'Workout',
      desc: '',
      args: [],
    );
  }

  /// `Cairo`
  String get Cairo {
    return Intl.message(
      'Cairo',
      name: 'Cairo',
      desc: '',
      args: [],
    );
  }

  /// `Photo Library`
  String get Gallery {
    return Intl.message(
      'Photo Library',
      name: 'Gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get Camera {
    return Intl.message(
      'Camera',
      name: 'Camera',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Rooms`
  String get Rooms {
    return Intl.message(
      'Rooms',
      name: 'Rooms',
      desc: '',
      args: [],
    );
  }

  /// `Reservations`
  String get Reservations {
    return Intl.message(
      'Reservations',
      name: 'Reservations',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get Statistics {
    return Intl.message(
      'Statistics',
      name: 'Statistics',
      desc: '',
      args: [],
    );
  }

  /// `Feedbacks`
  String get Feedbacks {
    return Intl.message(
      'Feedbacks',
      name: 'Feedbacks',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get Welcome {
    return Intl.message(
      'Welcome',
      name: 'Welcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Don\'t have an account? `
  String get RegisterQuestion {
    return Intl.message(
      'Don\\\'t have an account? ',
      name: 'RegisterQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message(
      'Register',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get Name {
    return Intl.message(
      'Full Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get Phone {
    return Intl.message(
      'Phone Number',
      name: 'Phone',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get CPassword {
    return Intl.message(
      'Confirm Password',
      name: 'CPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get LoginQuestion {
    return Intl.message(
      'Already have an account? ',
      name: 'LoginQuestion',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get City {
    return Intl.message(
      'City',
      name: 'City',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get Region {
    return Intl.message(
      'Region',
      name: 'Region',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get Update {
    return Intl.message(
      'Update',
      name: 'Update',
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
      Locale.fromSubtags(languageCode: 'ar'),
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
