import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xmpp_chat_demo_flutter/app.dart';

Future<void> _logFlutterOnError(FlutterErrorDetails details) async {
  Zone.current.handleUncaughtError(
      details.exception, details.stack ?? StackTrace.current);
}

Future<void> main() async {
  runZonedGuarded(() async {
    FlutterError.onError = _logFlutterOnError;

    runApp(
      const XmppApp(),
    );
  }, (Object error, StackTrace stackTrace) {});
}
