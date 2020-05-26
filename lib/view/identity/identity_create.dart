import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/own_profile.dart';
import 'package:mochi/view/dialog_modify_profile.dart';
import 'package:mochi/view/own_profile_display_picture.dart';
import 'package:mochi_mobile/mochi_mobile.dart';
import 'package:mochi_mobile/identity.dart';

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

  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    void _openFileExplorer() async {
      String _path;
      Map<String, String> _paths;
      try {
        _paths = null;
        _path = await FilePicker.getFilePath(
          type: FileType.any,
        );
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        displayPicture = base64String(File(_path).readAsBytesSync());
      });
    }

    final TextTheme textTheme = Theme.of(context).textTheme;


    final nameController = TextEditingController(    );
    // final displayPictureController = TextEditingController(    );

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
        // width: dialogContentWidth,
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
            // Row(
            //   children: <Widget>[
            //     Container(
            //       width: 100,
            //       height: 100,
            //       child: () {
            //         // if (displayPicture == null || displayPicture.isEmpty) {
            //         //   return OwnProfileDisplayPicture(
            //         //     profile: widget.profile,
            //         //     size: 100,
            //         //   );
            //         // }
            //         return OwnProfileDisplayPicture(
            //           profile: widget.,
            //           image: MemoryImage(
            //             base64.decode(displayPicture),
            //           ),
            //           size: 100,
            //         );
            //       }(),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Container(
            //   child: RaisedButton(
            //     padding: EdgeInsets.all(15),
            //     onPressed: () {
            //       var b = _selectFile();
            //       b.then((String d) {
            //         setState(() {
            //           displayPicture = d;
            //         });
            //       });
            //     },
            //     child: Container(
            //       child: Center(
            //         child: Text(
            //           'Pick new display picture',
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            // Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              // children: <Widget>[
Container(
                    padding: EdgeInsets.only(top: 15),
  child:                RaisedButton(
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
                    // widget.callback(
                    //   true,
                    //   nameController.text,
                    //   displayPicture,
                    // );
                      MochiMobile.createNewIdentity(
                      name,
                    ).then((Identity identity) {
                      Repository.get().putIdentity(identity).then((value) {
                        Navigator.pushNamed(context, '/identity-created');
                      });
                    });
                  },
              //   ),
              // ],
            ),
            ),
          ],
        ),
      ),
              // child: UpdateOwnProfileDialog(
              //   saveButtonText: "Create identity",
              //   profile: OwnProfile(
              //     key: "",
              //   ),
              //   callback: (
              //     bool update,
              //     String name,
              //     String displayPicture,
              //   ) {
              //     if (update) {
              //       MochiMobile.createNewIdentity(
              //         name,
              //       ).then((Identity identity) {
              //         Repository.get().putIdentity(identity).then((value) {
              //           Navigator.pushNamed(context, '/identity-created');
              //         });
              //       });
              //     }
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Future<String> _selectFile() async {
    String _path;
    try {
      _path = await FilePicker.getFilePath(
        type: FileType.image,
      );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    var b = File(_path).readAsBytesSync();
    var s = base64String(b);
    return s;
  }
}
