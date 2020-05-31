import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:identity/data/repository.dart';
import 'package:identity_mobile/identity.dart';
import 'package:identity_mobile/identity_mobile.dart';

String base64String(Uint8List data) {
  return base64Encode(data);
}

class IdentityCreateScreen extends StatefulWidget {
  @override
  _IdentityCreateScreenState createState() => _IdentityCreateScreenState();
}

class _IdentityCreateScreenState extends State<IdentityCreateScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String name;
  String displayPicture;

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        bottomOpacity: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Create new identity',
                textAlign: TextAlign.left,
                style: textTheme.headline4,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your name will be displayed on all your public and private interactions.',
                textAlign: TextAlign.left,
                style: textTheme.bodyText1,
              ),
            ),
            Expanded(
              child: new Container(
                padding: EdgeInsets.all(10),
                child: new ListView(
                  children: <Widget>[
                    new TextField(
                      controller: nameController,
                      decoration: new InputDecoration(
                        labelText: 'Name',
                        hintText: 'John Doe',
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xFF6697FF),
                        padding: EdgeInsets.all(15),
                        child: Container(
                          child: Center(
                            child: Text(
                              'Create',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          IdentityMobile.createNewIdentity(
                            name,
                          ).then((Identity identity) {
                            Repository.get()
                                .putIdentity(identity)
                                .then((value) {
                              Navigator.pushNamed(context, '/identity-created');
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
