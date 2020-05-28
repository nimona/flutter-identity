import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:identity/data/repository.dart';

import 'package:identity_mobile/identity.dart';
import 'package:local_auth_device_credentials/local_auth.dart';
import 'package:settings_ui/settings_ui.dart';

class MasterDetailLayout extends StatefulWidget {
  @override
  _MasterDetailLayoutState createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  Future<Identity> identityFuture;

  @override
  void initState() {
    super.initState();

    _getAvailableBiometrics();
    _checkBiometrics();
    Repository.get().getMustAuthenticate().then((v) {
      _mustAuthenticate = v;
    });
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

  final LocalAuthentication auth = LocalAuthentication();

  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  // String _authorized = 'Not Authorized';
  // bool _isAuthenticating = false;
  // bool _isAuthenticated = false;
  // bool _hasIdentity = false;
  bool _mustAuthenticate = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
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

    bool lockInBackground = true;
    bool notificationsEnabled = true;

    final TextStyle headerStyle = TextStyle(
      color: Colors.grey.shade800,
      // fontWeight: FontWeight.bold,
      // fontSize: 20.0,
    );

    return Scaffold(
      appBar: EmptyAppBar(),
      // backgroundColor: Colors.white,
      backgroundColor: Color(0xFFFAFAFA),

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

          return Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // SizedBox(
                //   height: 15.0,
                // ),
                // Opacity(
                //   opacity: 0.87,
                //   child: Container(
                //     width: 100,
                //     height: 113,
                //     decoration: BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage(
                //           'images/nimona-blue.png',
                //         ),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 15.0,
                // ),
                Text(
                  "Identity",
                  textAlign: TextAlign.left,
                  style: headerStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  // margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    // border: Border.all(color: Colors.black26),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      size: 40.0,
                    ),
                    title: Text(
                      "Public key",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data.publicKey,
                      textAlign: TextAlign.left,
                      style: textTheme.bodyText2.copyWith(
                        fontFamily: "Courier",
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    selected: false,
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: snapshot.data.publicKey,
                        ),
                      );
                      showDefaultSnackbar(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Settings",
                  textAlign: TextAlign.left,
                  style: headerStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  // margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  // height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    // border: Border.all(color: Colors.black26),
                  ),
                  child: SwitchListTile(
                    secondary: Icon(
                      Icons.fingerprint,
                      // size: 40.0,
                    ),
                    title: Text(
                      () {
                        if (_availableBiometrics.length == 0) {
                          return "...";
                        }
                        if (_availableBiometrics[0] == BiometricType.face) {
                          return "Require Face ID to unlock";
                        }
                        if (_availableBiometrics[0] ==
                            BiometricType.fingerprint) {
                          return "Require Touch ID to unlock";
                        }
                        return "Require biometric unlock";
                      }(),
                      // _availableBiometrics.toString(),
                      // "Use TouchID to unlock",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    // subtitle: Text(
                    //   snapshot.data.publicKey,
                    //   textAlign: TextAlign.left,
                    //   style: textTheme.bodyText2.copyWith(
                    //     fontFamily: "Courier",
                    //     color: Colors.grey,
                    //   ),
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    value: _mustAuthenticate,
                    // selected: false,
                    onChanged: (newMustAuth) {
                      auth
                          .authenticate(
                        localizedReason: 'Authentication for Nimona Identity',
                        useErrorDialogs: true,
                        stickyAuth: true,
                      )
                          .then(
                        (ok) {
                          if (!ok) {
                            return;
                          }
                          Repository.get().setMustAuthenticate(newMustAuth);
                          setState(
                            () {
                              _mustAuthenticate = newMustAuth;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );

          // List<String> words = snapshot.data.identitySecretPhrase;
          //     return Container(
          //       padding: EdgeInsets.all(15),
          //       child: Center(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.max,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             Text(
          //               'Your identity',
          //               textAlign: TextAlign.left,
          //               style: textTheme.headline4,
          //             ),
          //             // SizedBox(
          //             //   height: 10,
          //             // ),
          //             Divider(
          //               height: 5.0,
          //               color: Colors.grey,
          //             ),
          //             ListTile(
          //               title: Text("Public key"),
          //             ),
          //             ListTile(
          //               title: Text(
          //                 snapshot.data.publicKey,
          //                 textAlign: TextAlign.left,
          //                 style: textTheme.bodyText2.copyWith(
          //                   fontFamily: "Courier",
          //                 ),
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //               subtitle: Text(
          //                 'Your public key is how others can find and identity you.',
          //               ),
          //               onTap: () {},
          //             ),
          //             // Text(
          //             //   'Your public key is how others can find and identity you.',
          //             //   textAlign: TextAlign.left,
          //             // ),
          //             // Text(
          //             //   'It is perfectly ok to share it with anyone.',
          //             //   textAlign: TextAlign.left,
          //             // ),
          //             // SizedBox(
          //             //   height: 10,
          //             // ),
          //             // Text(
          //             //   snapshot.data.publicKey,
          //             //   textAlign: TextAlign.left,
          //             //   style: textTheme.bodyText2.copyWith(
          //             //     fontFamily: "Courier",
          //             //   ),
          //             //   overflow: TextOverflow.ellipsis,
          //             // ),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             GestureDetector(
          //               onTap: () {
          //                 Clipboard.setData(
          //                   ClipboardData(
          //                     text: snapshot.data.publicKey,
          //                   ),
          //                 );
          //                 showDefaultSnackbar(context);
          //               },
          //               child: Container(
          //                 // padding: EdgeInsets.only(top: 25, bottom: 10),
          //                 child: Text(
          //                   'Copy to clipboard',
          //                   style: TextStyle(
          //                     color: Color(0xFF6697FF),
          //                     // fontSize: 14,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             // Text(
          //             //   'Your very secret phrase.',
          //             //   textAlign: TextAlign.left,
          //             //   // style: textTheme.headline4,
          //             // ),
          //             Expanded(
          //               child: Container(),
          //             ),
          //             Container(
          //               alignment: Alignment.bottomCenter,
          //               padding: EdgeInsets.only(bottom: 15),
          //               child: RaisedButton(
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10.0),
          //                 ),
          //                 onPressed: () {
          //                   removeIdentity(context);
          //                   // Repository.get().removeIdentity();
          //                   // Navigator.pushNamedAndRemoveUntil(
          //                   //   context,
          //                   //   "/",
          //                   //   (_) => false,
          //                   // );
          //                 },
          //                 color: Colors.red,
          //                 child: Container(
          //                   child: Center(
          //                     child: Text(
          //                       'Remove identity',
          //                       style: TextStyle(
          //                         // fontSize: textTheme.bodyText2.fontSize,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
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
