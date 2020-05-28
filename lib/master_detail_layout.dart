import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:identity/data/repository.dart';
import 'package:identity/view/identity/identity_created.dart';

import 'package:identity_mobile/identity.dart';
import 'package:local_auth_device_credentials/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  void showDefaultSnackbar(String s, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
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

  bool _privateKeySeedVisible = false;
  bool _privateKeyQRVisible = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

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
          List<String> words = snapshot.data.privateKeyMnemonic.split(" ");

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
                  // height: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    // border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          // Icons.info_outline,
                          MaterialIcons.perm_identity,
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
                          showDefaultSnackbar("Public key copied", context);
                        },
                      ),

                      // SEED

                      SwitchListTile(
                        secondary: Icon(
                          Foundation.key,
                          size: 40.0,
                        ),
                        title: Text(
                          "Show private key seed",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        subtitle: Text(
                          "You should keep this private",
                          textAlign: TextAlign.left,
                          style: textTheme.bodyText2.copyWith(
                            // fontFamily: "Courier",
                            // color: Colors.red,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // selected: false,
                        value: _privateKeySeedVisible,
                        onChanged: (v) {
                          // Clipboard.setData(
                          //   ClipboardData(
                          //     text: snapshot.data.publicKey,
                          //   ),
                          // );
                          // showDefaultSnackbar(context);
                          setState(() {
                            _privateKeyQRVisible = false;
                            _privateKeySeedVisible = v;
                          });
                        },
                      ),
                      () {
                        if (!_privateKeySeedVisible) {
                          return Container();
                        }
                        return Container(
                          // margin: EdgeInsets.only(bottom: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black26,
                              //     blurRadius: 15.0,
                              //   ),
                              // ],
                            ),
                            padding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                              // bottom: 15,
                            ),
                            child: Column(
                              children: <Widget>[
                                WordsRow(index: 0, words: words),
                                WordsRow(index: 3, words: words),
                                WordsRow(index: 6, words: words),
                                WordsRow(index: 9, words: words),
                                WordsRow(index: 12, words: words),
                                WordsRow(index: 15, words: words),
                                WordsRow(index: 18, words: words),
                                WordsRow(index: 21, words: words),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    child: Text("Copy to clipboard"),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: words.join(" "),
                                        ),
                                      );
                                      showDefaultSnackbar(
                                        "Seed copied",
                                        context,
                                      );
                                    },
                                    color: theme.accentColor,
                                    textColor: Colors.white,
                                    // on
                                  ),
                                ),
                                // Builder(
                                //   builder: (BuildContext context) {
                                //     return GestureDetector(
                                //       onTap: () {
                                //         Clipboard.setData(
                                //           ClipboardData(
                                //             text: () {
                                //               var phrase = '';
                                //               for (var i = 0;
                                //                   i < words.length;
                                //                   i++) {
                                //                 var word = words[i];
                                //                 if (i % 4 == 0) {
                                //                   phrase =
                                //                       phrase.trimRight() + "\n";
                                //                 }
                                //                 phrase +=
                                //                     "${(i + 1).toString().padLeft(2, ' ')}";
                                //                 phrase +=
                                //                     ": ${word.padRight(10, ' ')}";
                                //               }
                                //               return phrase.trimRight();
                                //             }(),
                                //           ),
                                //         );
                                //         showDefaultSnackbar(
                                //             "Seed copied", context);
                                //       },
                                //       child: Container(
                                //         padding: EdgeInsets.only(
                                //             top: 25, bottom: 10),
                                //         child: Text(
                                //           'Copy to clipboard',
                                //           style: TextStyle(
                                //             color: Color(0xFF6697FF),
                                //             // fontSize: 14,
                                //             fontWeight: FontWeight.bold,
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        );
                      }(),

// QR CODE

                      SwitchListTile(
                        secondary: Icon(
                          MaterialCommunityIcons.qrcode,
                          size: 40.0,
                        ),
                        title: Text(
                          "Show private key QR code",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        subtitle: Text(
                          "You should keep this private too",
                          textAlign: TextAlign.left,
                          style: textTheme.bodyText2.copyWith(
                            // fontFamily: "Courier",
                            // color: Colors.red,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // selected: false,
                        value: _privateKeyQRVisible,
                        onChanged: (v) {
                          // Clipboard.setData(
                          //   ClipboardData(
                          //     text: snapshot.data.publicKey,
                          //   ),
                          // );
                          // showDefaultSnackbar(context);
                          setState(() {
                            _privateKeySeedVisible = false;
                            _privateKeyQRVisible = v;
                          });
                        },
                      ),
                      () {
                        if (!_privateKeyQRVisible) {
                          return Container();
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: QrImage(
                            data: words.join(" "),
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        );
                      }(),
                    ],
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
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Container(),
                ),
                // Text(
                //   "Danger!",
                //   textAlign: TextAlign.left,
                //   style: headerStyle.copyWith(
                //     color: Colors.red,
                //   ),
                // ),
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
                    color: Colors.red,
                    child: Container(
                      child: Center(
                        child: Text(
                          'Remove identity',
                          style: TextStyle(
                            // fontSize: textTheme.bodyText2.fontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
