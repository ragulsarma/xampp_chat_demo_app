import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:xmpp_chat_demo_flutter/Animation/AnimationBuildLogin.dart';
import 'package:xmpp_chat_demo_flutter/constants/ColorGlobal.dart';
import 'package:xmpp_chat_demo_flutter/constants/TextField.dart';
import 'package:xmpp_plugin/error_response_event.dart';
import 'package:xmpp_plugin/models/chat_state_model.dart';
import 'package:xmpp_plugin/models/connection_event.dart';
import 'package:xmpp_plugin/models/message_model.dart';
import 'package:xmpp_plugin/models/present_mode.dart';
import 'package:xmpp_plugin/success_response_event.dart';
import 'package:xmpp_plugin/xmpp_plugin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    with WidgetsBindingObserver
    implements DataChangeEvents {
  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;

  double width = 180.0;
  double widthIcon = 200.0;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  static late XmppConnection flutterXmpp;
  bool isLoading = false;
  String connectionStatus = "Disconnected";

  getDisposeController() {
    email.clear();
    password.clear();
    emailFocus.unfocus();
    passwordFocus.unfocus();
  }

  static const snackBar = SnackBar(
    content: Text('Connecting to server...'),
  );

  @override
  void initState() {
    super.initState();
    XmppConnection.addListener(this);
    getDisposeController();
  }

  @override
  void dispose() {
    XmppConnection.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    log('didChangeAppLifecycleState() dispose');

    getDisposeController();

    super.dispose();
  }

  var list = [
    Colors.lightGreen,
    Colors.redAccent,
  ];

  Future<void> connect() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    try {
      final auth = {
        "user_jid": "",
        "password": "",
        "host": "xmpphost",
        "port": '5222',
        "nativeLogFilePath": "filepath",
        "requireSSLConnection": false,
        "autoDeliveryReceipt": true,
        "useStreamManagement": false,
        "automaticReconnection": true,
      };

      flutterXmpp = XmppConnection(auth);
      await flutterXmpp.start(_onError);
      await flutterXmpp.login();
    } catch (e) {
      print('xmpp exception connect ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorGlobal.whiteColor,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(),
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorGlobal.colorPrimaryDark.withOpacity(0.7),
                    ColorGlobal.colorPrimary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuad,
              child: AnimationBuildLogin(
                size: size,
                yOffset: size.height / 1.26,
                color: ColorGlobal.whiteColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome Back !',
                    style: TextStyle(
                      color: ColorGlobal.whiteColor,
                      fontSize: 24.0,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 22,
                left: 22,
                bottom: 22,
                top: 200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFieldWidget(
                    hintText: '',
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,
                    textEditingController: email,
                    focusNode: emailFocus,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  TextFieldWidget(
                    hintText: '******',
                    obscureText: true,
                    prefixIconData: Icons.lock,
                    textEditingController: password,
                    focusNode: passwordFocus,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(right: 8, top: 18),
                      child: Text(
                        "Forget Password ?",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorGlobal.whiteColor.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(
                        top: 60,
                        right: (8),
                        left: (8),
                        bottom: (20),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Material(
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  connect();
                                },
                                child: Hero(
                                  tag: 'blackBox',
                                  flightShuttleBuilder: (
                                    BuildContext flightContext,
                                    Animation<double> animation,
                                    HeroFlightDirection flightDirection,
                                    BuildContext fromHeroContext,
                                    BuildContext toHeroContext,
                                  ) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: ColorGlobal.colorPrimaryDark,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: (60.0),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            ColorGlobal.whiteColor,
                                            ColorGlobal.whiteColor
                                                .withOpacity(0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorGlobal.colorPrimary
                                                .withOpacity(0.6),
                                            spreadRadius: 5,
                                            blurRadius: 20,
                                            // changes position of shadow
                                          ),
                                        ],
                                        border: Border.all(
                                          width: 2,
                                          color: ColorGlobal
                                              .colorPrimaryDark, //                   <--- border width here
                                        ),
                                        color: ColorGlobal.whiteColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular((22.0)))),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "CONNECT",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          color: ColorGlobal.colorPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onChatMessage(MessageChat messageChat) {
    log('onChatMessage ~~>>${messageChat.body.toString() + messageChat.senderJid.toString()}');
  }

  @override
  void onChatStateChange(ChatState chatState) {
    log('onChatStateChange ~~>>${chatState.senderJid.toString()}');
  }

  @override
  void onConnectionEvents(ConnectionEvent connectionEvent) {
    log('onConnectionEvents ~~>>${connectionEvent.toJson()}');
    connectionStatus = connectionEvent.type!.name;
    print('------------ $connectionStatus');
  }

  @override
  void onGroupMessage(MessageChat messageChat) {
    // TODO: implement onGroupMessage
  }

  @override
  void onNormalMessage(MessageChat messageChat) {
    // TODO: implement onNormalMessage
  }

  @override
  void onPresenceChange(PresentModel message) {
    // TODO: implement onPresenceChange
  }

  void _onError(Object error) {
    // TODO : Handle the Error event
    print('receiveEvent onXmppError 222: ${error}');
  }

  @override
  void onXmppError(ErrorResponseEvent errorResponseEvent) {
    print(
        'receiveEvent onXmppError: ${errorResponseEvent.toErrorResponseData().toString()}');
  }

  @override
  void onSuccessEvent(SuccessResponseEvent successResponseEvent) {
    print(
        'receiveEvent successEventReceive: ${successResponseEvent.toSuccessResponseData().toString()}');
  }
}
