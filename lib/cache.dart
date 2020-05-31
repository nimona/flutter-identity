import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CacheControl extends WidgetsBindingObserver {
  CacheControl() {
    WidgetsBinding.instance.addObserver(this);
  }

  // void _cleanAllCache() {
  //   // Cleans all cache.
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      print(state);
    print(state);
    print(state);
    print(state);
    print(state);
    print(state);
    print(state);
    print(state);
    print(state);
    print(state);
    print(state);
 
 if (state == AppLifecycleState.detached) {
      // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      // if (Platform.isIOS) {
      //   exit(0);
      // }
      // new Future.delayed(
      //    const Duration(minutes: 15),
      //    _cleanAllCache,
      // );
    }
  }
}