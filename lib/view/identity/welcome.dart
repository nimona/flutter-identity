import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_device_credentials/local_auth.dart';
import 'package:identity/data/repository.dart';

import 'package:identity/view/identity/delayed_animation.dart';
import 'package:identity_mobile/identity.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<Identity> identity;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _isAuthenticated = false;
  bool _hasIdentity = false;

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

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Authentication for Nimona Identity',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticated = false;
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      if (_hasIdentity && authenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/main",
          (_) => false,
        );
        return;
      }
      _isAuthenticated = authenticated;
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  void initState() {
    super.initState();
    identity = Repository.get().getIdentity();
    identity.then((Identity id) {
      if (id != null && id.privateKey != null && id.privateKey != "") {
        setState(() {
          _hasIdentity = true;
          // _authenticate();
        });
        // auth
        //     .authenticateWithBiometrics(
        //         localizedReason: 'Scan your fingerprint to authenticate',
        //         useErrorDialogs: true,
        //         stickyAuth: true)
        //     .then((bool v) {
        //   if (v == true) {
        //     Navigator.pushNamedAndRemoveUntil(
        //       context,
        //       "/main",
        //       (_) => false,
        //     );
        //   }
        // });
      }
      return;
    });
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
                        if (_hasIdentity) {
                          if (_isAuthenticating || !_isAuthenticated) {
                            return   DelayedAnimation(
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
                                        // fontSize: textTheme.bodyText1.fontSize,
                                        // fontWeight: FontWeight.bold,
                                        color: Color(0xFF6697FF),
                                    ),
                                  ),
                                ),
                              ),
                              ),
                            );
                          }
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
                                  Navigator.pushNamed(
                                      context, '/identity-create');
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
