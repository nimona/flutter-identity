import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:identity/data/repository.dart';

import 'package:identity_mobile/identity.dart';

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
        content: Text('Public key copied'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

     removeIdentity(BuildContext context) {
                          // set up the buttons
                          Widget cancelButton = FlatButton(
                            child: Text("Nevermind"),
                            onPressed: () {
                               Navigator.of(context).pop(); 
                            },
                          );
                          Widget continueButton = FlatButton(
                            child: Text(
                              "Remove identity",
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                              ),
                            onPressed: () {
                                 Repository.get().removeIdentity();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/",
                          (_) => false,
                        );
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Remove identity"),
                            content: Text(
                                "Are you sure you want to remove this identity from your phone?",
                                // "\nBefore you do, make sure you have your private key seed backed up.",
                                ),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }

    return Scaffold(
      appBar: EmptyAppBar(),
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your identity',
                    textAlign: TextAlign.left,
                    style: textTheme.headline4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your public key is how others can find and identity you.',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'It is perfectly ok to share it with anyone.',
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.data.publicKey,
                    textAlign: TextAlign.left,
                    style: textTheme.bodyText2.copyWith(
                      fontFamily: "Courier",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: snapshot.data.publicKey,
                        ),
                      );
                      showDefaultSnackbar(context);
                    },
                    child: Container(
                      // padding: EdgeInsets.only(top: 25, bottom: 10),
                      child: Text(
                        'Copy to clipboard',
                        style: TextStyle(
                          color: Color(0xFF6697FF),
                          // fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   'Your very secret phrase.',
                  //   textAlign: TextAlign.left,
                  //   // style: textTheme.headline4,
                  // ),

                  Expanded(
                    child: Container(),
                  ),
// Align(
                  // alignment: Alignment.bottomCenter,
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 15),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                       removeIdentity(context);
                        // Repository.get().removeIdentity();
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   "/",
                        //   (_) => false,
                        // );
                      },
                      color: Colors.redAccent,
                      child: Container(
                        child: Center(
                          child: Text(
                            'Wipe secure storage',
                            style: TextStyle(
                              // fontSize: textTheme.bodyText2.fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        //   ),
                      ),
                      // ),
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

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
