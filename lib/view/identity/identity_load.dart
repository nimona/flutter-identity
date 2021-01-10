import 'dart:io' show Platform;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:identity/data/repository.dart';
import 'package:identity_mobile/identity_mobile.dart';

class IdentityLoadScreen extends StatefulWidget {
  @override
  _IdentityLoadScreenState createState() => _IdentityLoadScreenState();
}

class _IdentityLoadScreenState extends State<IdentityLoadScreen>
    with WidgetsBindingObserver {
  TextEditingController mnemonicPhraseCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  FocusNode _focusNode = new FocusNode();
  final _textKey = GlobalKey<FormState>();

  String _hasError;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Use existing identity.',
                  textAlign: TextAlign.left,
                  style: textTheme.headline5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please paste or type in your mnemonic seed.',
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Line breaks, numbers, and special characters will be ignored.',
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  minLines: 1,
                  maxLines: 24,
                  style: TextStyle(
                    fontFamily: "Courier",
                  ),
                  key: _textKey,
                  focusNode: _focusNode,
                  controller: mnemonicPhraseCtrl,
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Color(0xFF4d85ff)),
                    ),
                    suffixIcon: () {
                      if (Platform.isFuchsia) {
                        return null;
                      }
                      if (Platform.isWindows) {
                        return null;
                      }
                      if (Platform.isLinux) {
                        return null;
                      }
                      if (Platform.isMacOS) {
                        return null;
                      }
                      return IconButton(
                        icon: Icon(MaterialCommunityIcons.qrcode_scan),
                        onPressed: () {
                          _focusNode.unfocus();
                          BarcodeScanner.scan().then(
                            (v) {
                              if (v.rawContent != "") {
                                mnemonicPhraseCtrl.text = v.rawContent;
                              }
                            },
                          );
                        },
                      );
                    }(),
                    labelText: 'Mnemonic phrase',
                    labelStyle: TextStyle(
                      fontFamily: textTheme.bodyText1.fontFamily,
                      fontSize: textTheme.headline6.fontSize,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(15),
                    onPressed: () {
                      setState(() {
                        _hasError = "";
                      });
                      IdentityMobile.importNewIdentityString(
                        mnemonicPhraseCtrl.text,
                      ).then(
                        (identity) {
                          print(identity.privateKey);
                          Repository.get().putIdentity(identity).then(
                            (v) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/main",
                                (_) => false,
                              );
                            },
                          );
                        },
                      ).catchError(
                        (e) {
                          setState(() {
                            _hasError = e.toString();
                          });
                        },
                      );
                    },
                    color: Color(0xFF6697FF),
                    child: Container(
                      child: Center(
                        child: Text(
                          'Import identity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                () {
                  if (_hasError == null || _hasError == "") {
                    return Container();
                  }
                  return Text(
                    _hasError ?? "",
                    textAlign: TextAlign.left,
                  );
                }(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
