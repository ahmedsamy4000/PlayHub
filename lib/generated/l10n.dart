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

  /// `Owner`
  String get Owner {
    return Intl.message(
      'Owner',
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
