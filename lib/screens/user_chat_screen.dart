import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:xmpp_chat_demo_flutter/screens/login_screen.dart';
import 'package:xmpp_plugin/error_response_event.dart';
import 'package:xmpp_plugin/models/chat_state_model.dart';
import 'package:xmpp_plugin/models/connection_event.dart';
import 'package:xmpp_plugin/models/message_model.dart';
import 'package:xmpp_plugin/models/present_mode.dart';
import 'package:xmpp_plugin/success_response_event.dart';
import 'package:xmpp_plugin/xmpp_plugin.dart';

class UserChatScreen extends StatefulWidget {
  final String userName;
  final String userJID;

  const UserChatScreen(
      {super.key, required this.userName, required this.userJID});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen>
    with WidgetsBindingObserver
    implements DataChangeEvents {
  final TextEditingController _msgController = TextEditingController();
  List<MessageChat> incomingMsgList = [];

  void sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      int id = DateTime.now().millisecondsSinceEpoch;

      final userJID = widget.userJID.replaceAll(":", "").replaceAll(" ", "");
      await LoginScreenState.flutterXmpp.sendMessageWithType(userJID,
          _msgController.text, "$id", DateTime.now().millisecondsSinceEpoch);

      incomingMsgList
          .add(MessageChat(body: _msgController.text, type: "sender"));

      _msgController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    XmppConnection.addListener(this);
  }

  @override
  void dispose() {
    XmppConnection.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    log('didChangeAppLifecycleState() dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-photo/close-up-young-successful-man-smiling-camera-standing-casual-outfit-against-blue-background_1258-66609.jpg?w=2000"),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.userName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          ListView.builder(
            itemCount: incomingMsgList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (incomingMsgList[index].type == "sender"
                      ? Alignment.topRight
                      : Alignment.topLeft),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (incomingMsgList[index].type == "sender"
                          ? Colors.blue[200]
                          : Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      incomingMsgList[index].time ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                        onPressed: () => sendMsg(),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ))
                  ])))
        ]));
  }

  @override
  void onChatMessage(MessageChat messageChat) {
    log('onChatMessage chat screen ~~>>${messageChat.body.toString()}');
    if (messageChat.type == 'chatstate' &&
        (messageChat.body ?? '').isNotEmpty) {
      incomingMsgList.add(messageChat);
      setState(() {});
    }
  }

  @override
  void onChatStateChange(ChatState chatState) {
    // TODO: implement onChatStateChange
  }

  @override
  void onConnectionEvents(ConnectionEvent connectionEvent) {
    // TODO: implement onConnectionEvents
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

  @override
  void onSuccessEvent(SuccessResponseEvent successResponseEvent) {
    // TODO: implement onSuccessEvent
  }

  @override
  void onXmppError(ErrorResponseEvent errorResponseEvent) {
    // TODO: implement onXmppError
  }
}
