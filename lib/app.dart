import 'package:flutter/material.dart';
import 'package:xmpp_chat_demo_flutter/login_screen.dart';

class XmppApp extends StatefulWidget {
  const XmppApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return XmppAppState();
  }
}

class XmppAppState extends State<XmppApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => 'Demo XMPP',
      routes: {
        MicroToDoRoutes.dashboard: (context) {
          return const LoginScreen();
        },
      },
    );
  }
}

class MicroToDoRoutes {
  //---to setup router path names--
  static const dashboard = '/';
  static const addTodo = '/addTodo';
  static const detailsScreen = '/todoDetails';
}
