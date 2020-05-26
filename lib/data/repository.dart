import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mochi/data/datastore.dart';
import 'package:mochi/data/ws_model/daemon_info_response.dart';
import 'package:mochi/data/wsdatastore.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message_block.dart';
import 'package:mochi/model/own_profile.dart';
import 'package:mochi_mobile/identity.dart';
import 'package:mochi_mobile/mochi_mobile.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  DataStore _dataStore = new WsDataStore();
  FlutterSecureStorage storage = new FlutterSecureStorage();

  Repository._internal() {
    // init
  }

  Future<void> putIdentity(Identity identity) {
    print("wrrrriiii");
    print(json.encode(identity).toString());
    try {
      return storage.write(
        key: "identity",
        value: json.encode(identity).toString(),
      );
    } catch (e) {
      print(">>>");
      print(">>>");
      print(">>>");
      print(">>>");
      print(e);
      throw e;
    }
  }

  Future<Identity> getIdentity() async {
    String idString = await storage.read(key: "identity");
    if (idString == null || idString == "") {
      return Identity();
    }
    print("idString");
    print(idString);
    Identity identity = Identity.fromJson(json.decode(idString));
    return identity;
  }

  Future<void> removeIdentity() async {
    return storage.deleteAll();
  }

  void createContact(String identityKey, String alias) {
    _dataStore.createContact(identityKey, alias);
  }

  void updateContact(String identityKey, String alias) {
    _dataStore.updateContact(identityKey, alias);
  }

  StreamController<Contact> getContacts() {
    StreamController<Contact> sc = new StreamController();
    sc.addStream(_dataStore.getContacts());
    return sc;
  }

  void createMessage(String conversationHash, String body) {
    _dataStore.createMessage(conversationHash, body);
  }

  StreamController<List<MessageBlock>> getMessagesForConversation(
    String conversationId,
  ) {
    StreamController<List<MessageBlock>> sc = new StreamController();
    sc.addStream(_dataStore.getMessagesForConversation(conversationId));
    return sc;
  }

  void joinConversation(String hash) {
    _dataStore.joinConversation(hash);
  }

  void createConversation(String name, String topic) {
    _dataStore.startConversation(name, topic);
  }

  void updateConversation(String hash, name, topic) {
    _dataStore.updateConversation(hash, name, topic);
  }

  void conversationMarkRead(String hash) {
    _dataStore.conversationMarkRead(hash);
  }

  void updateConversationDisplayPicture(String hash, diplayPicture) {
    _dataStore.updateConversationDisplayPicture(hash, diplayPicture);
  }

  void updateOwnProfile(String nameFirst, nameLast, displayPicture) {
    _dataStore.updateOwnProfile(nameFirst, nameLast, displayPicture);
  }

  StreamController<OwnProfile> getOwnProfile() {
    StreamController<OwnProfile> sc = new StreamController();
    sc.addStream(_dataStore.getOwnProfile());
    return sc;
  }

  StreamController<Conversation> getConversations() {
    StreamController<Conversation> sc = new StreamController();
    sc.addStream(_dataStore.getConversations());
    return sc;
  }

  Future<DaemonInfoResponse> daemonInfoGet() async {
    return _dataStore.daemonInfoGet();
  }

  Future<void> identityCreate(
      String nameFirst, nameLast, displayPicture) async {
    _dataStore.identityCreate(nameFirst, nameLast, displayPicture);
  }

  Future<void> identityLoad(String mnemonic) async {
    _dataStore.identityLoad(mnemonic);
  }
}
