import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mochi/data/repository.dart';

import 'package:mochi_mobile/identity.dart';


class MasterDetailLayout extends StatefulWidget {
  @override
  _MasterDetailLayoutState createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  Future<Identity> identityFuture;

  @override
  void initState() {
    super.initState();

    identityFuture = Repository.get().getIdentity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDefaultSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Secret phrase copied'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: identityFuture,
        builder: (
          BuildContext context,
          AsyncSnapshot<Identity> snapshot,
        ) {
          if (snapshot.data == null) {
            return Text("...");
          }
          print("111!");
          print(snapshot.data);
          print(jsonEncode(snapshot.data));
          // List<String> words = snapshot.data.identitySecretPhrase;
          return Container(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Yay!! 😊',
                    textAlign: TextAlign.left,
                    style: textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your public key',
                    textAlign: TextAlign.left,
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    snapshot.data.publicKey,
                    textAlign: TextAlign.left,
                    // style: textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Your very secret phrase.',
                    textAlign: TextAlign.left,
                    // style: textTheme.headline4,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        Repository.get().removeIdentity();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/",
                          (_) => false,
                        );
                      },
                      color: Colors.redAccent,
                      child: Container(
                        child: Center(
                          child: Text(
                            'Wipe secure storage',
                            style: TextStyle(
                              fontSize: textTheme.bodyText2.fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
