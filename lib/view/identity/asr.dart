import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:identity/data/repository.dart';
import 'package:identity_mobile/identity_mobile.dart';

import 'package:local_auth_device_credentials/local_auth.dart';

import 'package:identity/model/asr.dart';
import 'package:identity_mobile/identity.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class AuthorizationSigningPage extends StatefulWidget {
  const AuthorizationSigningPage({Key key, this.asrString}) : super(key: key);

  final String asrString;

  @override
  _AuthorizationSigningPageState createState() =>
      _AuthorizationSigningPageState();
}

class _AuthorizationSigningPageState extends State<AuthorizationSigningPage> {
  Future<Identity> identityFuture;

  AuthorizationSigningRequest asr;

  @override
  void initState() {
    super.initState();
    asr = AuthorizationSigningRequest.fromJson(json.decode(widget.asrString));
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

  String _err = "";
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    final TextStyle headerStyle = TextStyle(
      color: Colors.grey.shade800,
      // fontWeight: FontWeight.bold,
      // fontSize: 20.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Signing request"),
      ),
      // appBar: EmptyAppBar(),
      // backgroundColor: Colors.white,
      backgroundColor: Color(0xFFFAFAFA),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Text(
              //   "Signing request",
              //   textAlign: TextAlign.left,
              //   style: headerStyle,
              // ),
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
                        Feather.info,
                        size: 40.0,
                      ),
                      title: Text(
                        asr.dataO != null
                            ? asr.dataO.applicationNameS
                            : "Unknown application",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      subtitle: Text(
                        asr.dataO != null
                            ? asr.dataO.applicationDescriptionS
                            : widget.asrString,
                        textAlign: TextAlign.left,
                        style: textTheme.bodyText2.copyWith(
                          // fontFamily: "Courier",
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // selected: false,
                      // onTap: () {
                      //   // Clipboard.setData(
                      //   //   ClipboardData(
                      //   //     text: snapshot.data.publicKey,
                      //   //   ),
                      //   // );
                      //   // showDefaultSnackbar("Public key copied", context);
                      // },
                    ),
                    ListTile(
                      leading: Icon(
                        // Icons.info_outline,
                        Feather.folder,
                        size: 40.0,
                      ),
                      title: Text(
                        "Resources",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      subtitle: Text(
                        asr.dataO.resourcesAs.join(", "),
                        textAlign: TextAlign.left,
                        style: textTheme.bodyText2.copyWith(
                          // fontFamily: "Courier",
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        // Icons.info_outline,
                        Feather.zap,
                        size: 40.0,
                      ),
                      title: Text(
                        "Actions",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      subtitle: Text(
                        asr.dataO.actionsAs.join(", "),
                        textAlign: TextAlign.left,
                        style: textTheme.bodyText2.copyWith(
                          // fontFamily: "Courier",
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // SEED
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: ProgressButton.icon(
                  iconedButtons: {
                    ButtonState.idle: IconedButton(
                      text: "Sign authorization",
                      icon: Icon(
                        // Icons.send,
                        Ionicons.ios_send,
                        color: Colors.white,
                      ),
                      color: theme.accentColor,
                      // style: TextStyle(
                      //   color: Colors.white,
                      //   // fontWeight: FontWeight.w500,
                      // ),
                    ),
                    ButtonState.loading: IconedButton(
                      text: "Loading",
                      color: theme.accentColor,
                      // style: TextStyle(
                      //   color: Colors.white,
                      //   // fontWeight: FontWeight.w500,
                      // ),
                    ),
                    ButtonState.fail: IconedButton(
                      text: "Failed to deliver certificate",
                      icon: Icon(Icons.cancel, color: Colors.white),
                      color: Colors.red.shade300,
                      // style: TextStyle(
                      //   color: Colors.white,
                      //   // fontWeight: FontWeight.w500,
                      // ),
                    ),
                    ButtonState.success: IconedButton(
                      text: "Signed and delivered certificate",
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      color: Colors.green.shade400,
                      // style: TextStyle(
                      //   color: Colors.white,
                      //   // fontWeight: FontWeight.w500,
                      // ),
                    )
                  },
                  // stateColors: {
                  //   ButtonState.idle: theme.accentColor,
                  //   ButtonState.loading: theme.accentColor,
                  //   ButtonState.fail: Colors.red.shade300,
                  //   ButtonState.success: Colors.green.shade400,
                  // },
                  onPressed: () {
                    setState(() {
                      _err = "";
                    });
                    try {
                      Repository.get().getIdentity().then((id) {
                        setState(() {
                          stateTextWithIcon = ButtonState.loading;
                        });
                        IdentityMobile.signAuthorizationRequestString(
                          id.privateKey,
                          widget.asrString,
                        ).then((resp) {
                          if (resp == "ok?") {
                            setState(() {
                              // _resp = "Authorization signed and delived.";
                              stateTextWithIcon = ButtonState.success;
                            });
                          } else {
                            setState(() {
                              // _resp = "Error delivering singed authorization.";
                              _err = resp;
                              stateTextWithIcon = ButtonState.fail;
                            });
                          }
                        }).catchError(() {
                          setState(() {
                            // _resp = "Error delivering singed authorization.";
                            stateTextWithIcon = ButtonState.fail;
                          });
                        });
                      }).catchError(() {
                        setState(() {
                          // _resp = "Error delivering singed authorization.";
                          stateTextWithIcon = ButtonState.fail;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        // _resp = "Error delivering singed authorization.";
                        stateTextWithIcon = ButtonState.fail;
                      });
                    }
                  },
                  state: stateTextWithIcon,
                ),
                // child: ProgressButton(
                //   // defaultWidget: const Text('Sign authorization request'),
                //   // progressWidget: const CircularProgressIndicator(
                //   //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                //   // ),
                //   // width: 196,
                //   // height: 40,
                //   borderRadius: BorderRadius.all(Radius.circular(8)),
                //   strokeWidth: 2,
                //   child: Text(
                //     "Sample",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 24,
                //     ),
                //   ),
                //   // onPressed: (AnimationController controller) {
                //   //   if (controller.isCompleted) {
                //   //     controller.reverse();
                //   //   } else {
                //   //     controller.forward();
                //   //   }
                //   // },
                //   onPressed: (AnimationController controller) {
                //     setState(() {
                //       _resp = "";
                //     });
                //     Repository.get().getIdentity().then((id) {
                //       IdentityMobile.signAuthorizationRequestString(
                //         id.privateKey,
                //         widget.asrString,
                //       ).then((resp) {
                //         if (resp == "ok?") {
                //           setState(() {
                //             _resp = "Authorization signed and delived.";
                //           });
                //         } else {
                //           setState(() {
                //             _resp = "Error delivering singed authorization.";
                //           });
                //           controller.forward();
                //           // controller.
                //         }
                //       });
                //     });
                //   },
                // ),
                // child: RaisedButton(
                //   color: theme.primaryColor,
                //   child: Text(
                //     "Sign authorization",
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                //   onPressed: () {
                //     Repository.get().getIdentity().then((id) {
                //       IdentityMobile.signAuthorizationRequestString(
                //         id.privateKey,
                //         widget.asrString,
                //       ).then((r) {
                //         print("resp");
                //         print(r);
                //       });
                //     });
                //   },
                // ),
              ),
              SizedBox(
                height: 10,
              ),
              () {
                if (_err == "") {
                  return Container();
                }
                return Text(
                  _err,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              }(),
            ],
          ),
        ),
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
