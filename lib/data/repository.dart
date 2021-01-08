import 'dart:async';
import 'dart:convert';

import 'package:identity_mobile/identity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  Repository._internal();

  Future<void> putIdentity(Identity identity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("identity", json.encode(identity).toString());
    } catch (e) {
      throw e;
    }
  }

  Future<Identity> getIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idString = prefs.getString("identity");
    if (idString == null || idString == "") {
      return Identity();
    }
    Identity identity = Identity.fromJson(json.decode(idString));
    return identity;
  }

  Future<void> setMustAuthenticate(bool v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (v == true) {
      prefs.setBool("authentication", true);
    } else {
      prefs.remove("authentication");
    }
  }

  Future<bool> getMustAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool idString = prefs.getBool("authentication");
    if (idString == true) {
      return true;
    }
    return false;
  }

  Future<void> removeIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("authentication");
    prefs.remove("identity");
  }
}
