import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:local_auth_device_credentials/local_auth.dart';

import 'package:identity/data/repository.dart';
import 'package:identity_mobile/identity_mobile.dart';
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
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Signing request"),
      ),
      backgroundColor: Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
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
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
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
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
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
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
                        Ionicons.ios_send,
                        color: Colors.white,
                      ),
                      color: theme.accentColor,
                    ),
                    ButtonState.loading: IconedButton(
                      text: "Loading",
                      color: theme.accentColor,
                    ),
                    ButtonState.fail: IconedButton(
                      text: "Failed to deliver certificate",
                      icon: Icon(Icons.cancel, color: Colors.white),
                      color: Colors.red.shade300,
                    ),
                    ButtonState.success: IconedButton(
                      text: "Signed and delivered certificate",
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      color: Colors.green.shade400,
                    )
                  },
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
                              stateTextWithIcon = ButtonState.success;
                            });
                          } else {
                            setState(() {
                              _err = resp;
                              stateTextWithIcon = ButtonState.fail;
                            });
                          }
                        }).catchError(() {
                          setState(() {
                            stateTextWithIcon = ButtonState.fail;
                          });
                        });
                      }).catchError(() {
                        setState(() {
                          stateTextWithIcon = ButtonState.fail;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        stateTextWithIcon = ButtonState.fail;
                      });
                    }
                  },
                  state: stateTextWithIcon,
                ),
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
