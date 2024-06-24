import 'dart:convert';
import 'dart:developer';

import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preference {
  String? get currentId;
  set currentId(String? currentId);
  UserModel? get userData;
  Future<void> saveUserData(UserModel? appUser);
  Future<bool?> clear();
}
class LocalStorage extends Preference{
  static final LocalStorage _instance = LocalStorage._internal();
  SharedPreferences? sharedPreferences;

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal() {
    _init();
  }

  Future<void> _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveUserData(UserModel? appUser) async {
    log("saveUserData: $appUser");
    appUser == null
        ? sharedPreferences?.remove(const PreferencesKeys().appUserKey)
        :
    sharedPreferences?.setString(const PreferencesKeys().appUserKey, json.encode(appUser==null?UserModel().toJson():appUser.toJson()));
  log("saved");
  }

  @override
  UserModel? get userData {
    var appUser = sharedPreferences?.getString(const PreferencesKeys().appUserKey);
    log("$appUser");
    return appUser != null ? UserModel.fromJson(json.decode(appUser)) : null;
  }

  @override
  String? get currentId =>
      sharedPreferences?.getString(const PreferencesKeys().currentIdKey);

  @override
  set currentId(String? currentId) => currentId == null
      ? sharedPreferences?.remove(const PreferencesKeys().currentIdKey)
      : sharedPreferences?.setString(const PreferencesKeys().currentIdKey, currentId);

  @override
  Future<bool> clear() {
    return sharedPreferences?.clear() ?? Future.value(false);
  }


}

class PreferencesKeys {
  const PreferencesKeys();
  String get appUserKey => 'appUser';
  String get currentIdKey => 'currentId';
}