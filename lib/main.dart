import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:identity/view/identity/home.dart';
import 'package:identity/view/identity/identity_create.dart';
import 'package:identity/view/identity/identity_created.dart';
import 'package:identity/view/identity/identity_load.dart';
import 'package:identity/view/identity/welcome.dart';

void main() {
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identity',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/identity-load': (context) => IdentityLoadScreen(),
        '/identity-create': (context) => IdentityCreateScreen(),
        '/identity-created': (context) => IdentityCreatedScreen(),
        '/main': (context) => Home(),
      },
      theme: ThemeData(
        backgroundColor: Color(0xFFF3F3FB),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
    );
  }
}
