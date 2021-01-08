import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:identity_mobile/identity_mobile.dart';
import 'package:local_auth_device_credentials/local_auth.dart';

import 'package:identity/data/repository.dart';
import 'package:identity/view/identity/delayed_animation.dart';

import 'package:identity_mobile/identity.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _hasIdentity = false;
  bool _mustAuthenticate = false;

  Future<Identity> identity;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Authentication for Nimona Identity',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      if (_hasIdentity && authenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/main",
          (_) => false,
        );
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    identity = Repository.get().getIdentity();
    identity.then(
      (Identity id) {
        if (id != null && id.privateKey != null && id.privateKey != "") {
          setState(() {
            _hasIdentity = true;
          });
          if (_hasIdentity) {
            Repository.get().getMustAuthenticate().then(
              (v) {
                if (v == false) {
                  Future.delayed(const Duration(milliseconds: 2500), () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/main",
                      (_) => false,
                    );
                  });
                } else {
                  _authenticate();
                }
                _mustAuthenticate = v;
              },
            );
          }
        }
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0xFF6697FF),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: identity,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<Identity> snapshot,
                ) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text(
                      "Reticulating splines...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textTheme.caption.fontSize,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("Something went horribly wrong.\n" +
                        snapshot.error.toString());
                  }
                  return Column(
                    children: [
                      DelayedAnimation(
                        delay: 0,
                        child: Opacity(
                          opacity: 1,
                          child: Container(
                            width: 100,
                            height: 113,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'images/nimona-white.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      DelayedAnimation(
                        delay: 1000,
                        child: Text(
                          "Hey there!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textTheme.headline6.fontSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      () {
                        if (_hasIdentity && _mustAuthenticate) {
                          return DelayedAnimation(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(10),
                              onPressed: () {
                                _authenticate();
                              },
                              color: Colors.white,
                              child: Container(
                                width: 260,
                                child: Center(
                                  child: Text(
                                    'Authenticate',
                                    style: TextStyle(
                                      color: Color(0xFF6697FF),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        if (_hasIdentity) {
                          return Container();
                        }
                        return Column(
                          children: [
                            DelayedAnimation(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(15),
                                onPressed: () {
                                  // Navigator.pushNamed(
                                  //     context, '/identity-created');
                                  IdentityMobile.createNewIdentity(
                                    "",
                                  ).then((Identity identity) {
                                    Repository.get()
                                        .putIdentity(identity)
                                        .then((value) {
                                      Navigator.pushNamed(
                                          context, '/identity-created');
                                    });
                                  });
                                },
                                color: Colors.white,
                                child: Container(
                                  width: 260,
                                  child: Center(
                                    child: Text(
                                      'Create new identity',
                                      style: TextStyle(
                                        fontSize: textTheme.headline6.fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6697FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              delay: 1500,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            DelayedAnimation(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/identity-load');
                                },
                                color: Color(0xFF4d85ff),
                                child: Container(
                                  width: 260,
                                  child: Center(
                                    child: Text(
                                      'I already have one',
                                      style: TextStyle(
                                        fontSize: textTheme.bodyText2.fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              delay: 2000,
                            ),
                          ],
                        );
                      }(),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
