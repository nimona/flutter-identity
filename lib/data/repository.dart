import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:identity_mobile/identity.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  FlutterSecureStorage storage = new FlutterSecureStorage();

  Repository._internal() {  }

  Future<void> putIdentity(Identity identity) {
    try {
      return storage.write(
        key: "identity",
        value: json.encode(identity).toString(),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<Identity> getIdentity() async {
    String idString = await storage.read(key: "identity");
    if (idString == null || idString == "") {
      return Identity();
    }
    Identity identity = Identity.fromJson(json.decode(idString));
    return identity;
  }

  Future<void> setMustAuthenticate(bool v) async {
    if (v == true) {
      storage.write(key: "authentication", value: "true");
    } else {
      storage.delete(key: "authentication");
    }
  }

  Future<bool> getMustAuthenticate() async {
    String idString = await storage.read(key: "authentication");
    if (idString != null && idString == "true") {
      return true;
    }
    return false;
  }

  Future<void> removeIdentity() async {
    return storage.deleteAll();
  }
}
