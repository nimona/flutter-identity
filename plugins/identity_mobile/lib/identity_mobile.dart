import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:identity_mobile/identity.dart';

/// IdentityMobile is the top-level object that can be used to interact
/// with the go-hash native API (written in Go).
/// It used Flutter's MethodChannels to call the native code.
class IdentityMobile {
  static const MethodChannel _channel = const MethodChannel('identity_mobile');

  /// startDaemon starts a identity deamon if not already there.
  static Future<String> startDaemon() async {
    return await _channel.invokeMethod('startDaemon');
  }

  /// createNewIdentity and return it
  static Future<Identity> createNewIdentity(String name) async {
    // final asdf = _channel.invokeMethod('createNewidentity', name);
    // print(asdf);
    final idString = await _channel.invokeMethod('createNewIdentityString');
    Identity id = Identity.fromJson(json.decode(idString));
    print("createNewIdentity");
    print("createNewIdentity");
    print("createNewIdentity");
    print(idString);
    print(id.privateKey);
    print(id.publicKey);

    return id;
    // return Identity("","","","");
  }

  /// importNewIdentityString and return it
  static Future<Identity> importNewIdentityString(String mnemonic) async {
    // final asdf = _channel.invokeMethod('importNewIdentityString', name);
    // print(asdf);
    String idString;
    try {
      idString =
          await _channel.invokeMethod('importNewIdentityString', [mnemonic]);
      if (idString == null || idString == "") {
        throw "something bad happened";
      }
    } catch (e) {
      print("!!!!!!");
      print(e);
      throw e;
    }
    Identity id = Identity.fromJson(json.decode(idString));
    print("importNewIdentityString");
    print("importNewIdentityString");
    print("importNewIdentityString");
    print(idString);
    print(id.privateKey);
    print(id.publicKey);

    return id;
    // return Identity("","","","");
  }
}

// DateTime _timestamp(dynamic value) =>
//     new DateTime.fromMillisecondsSinceEpoch(value as int);

// /// IdentityDb represents a go-hash database.
// class IdentityDb {
//   final String filePath;
//   final List<Group> groups;

//   const IdentityDb(this.filePath, this.groups);

//   /// Function that converts an untyped [Map] (received from native code)
//   /// into a [IdentityDb] instance.
//   static IdentityDb from(String filePath, Map<dynamic, dynamic> map) {
//     List<Group> groups = new List<Group>();
//     map.forEach((key, contents) {
//       List<dynamic> contentList = contents;
//       var entries = contentList.map((e) => LoginInfo.from(e)).toList();
//       groups.add(new Group(key.toString(), entries));
//     });
//     return new IdentityDb(filePath, groups);
//   }
// }

// /// A group of [LoginInfo] entries in a [IdentityDb].
// class Group {
//   final String name;
//   final List<LoginInfo> entries;

//   const Group(this.name, this.entries);
// }

/// A group of [LoginInfo] entries in a [IdentityDb].

// /// LoginInfo represents a single entry in a [IdentityDb].
// class LoginInfo {
//   final String name, description, username, password, url;
//   final DateTime updatedAt;

//   const LoginInfo(this.name, this.description, this.username, this.password,
//       this.url, this.updatedAt);

//   /// Create a [LoginInfo] instance from an untyped [Map]
//   /// (received from native code).
//   LoginInfo.from(Map<dynamic, dynamic> map)
//       : name = map["name"] as String,
//         description = map['description'] as String,
//         username = map['username'] as String,
//         password = map['password'] as String,
//         url = map['url'] as String,
//         updatedAt = _timestamp(map['updatedAt']);
// }
