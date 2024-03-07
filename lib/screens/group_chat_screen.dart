import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_xmpp_login/screens/login_screen.dart';
import 'package:xmpp_plugin/error_response_event.dart';
import 'package:xmpp_plugin/models/chat_state_model.dart';
import 'package:xmpp_plugin/models/connection_event.dart';
import 'package:xmpp_plugin/models/message_model.dart';
import 'package:xmpp_plugin/models/present_mode.dart';
import 'package:xmpp_plugin/success_response_event.dart';
import 'package:xmpp_plugin/xmpp_plugin.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;

  const GroupChatScreen({Key? key, required this.groupName}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen>
    with WidgetsBindingObserver
    implements DataChangeEvents {
  List<MessageChat> incomingGrpMsgList = [];

  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  String valueText = '';

/*  void sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      int id = DateTime.now().millisecondsSinceEpoch;

      final groupName = widget.groupName.replaceAll(" ", "");

      await LoginScreenState.flutterXmpp.sendGroupMessage(
          '$groupName@conference.mongoose.netaxis.co',
          _msgController.text,
          "$id",
          DateTime.now().millisecondsSinceEpoch);

      incomingGrpMsgList
          .add(MessageChat(body: _msgController.text, type: "sender"));

      _msgController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() {});
    }
  }*/

  static const snackBar = SnackBar(
    content: Text('Invite has been sent.'),
  );

  Future<void> addMembersInGroup(String groupName, List<String> members) async {
    await LoginScreenState.flutterXmpp.addMembersInGroup(groupName, members);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invite user to group'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Enter user Id"),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.grey;
                  }),
                  textStyle: MaterialStateProperty.resolveWith((states) {
                    return TextStyle(color: Colors.white);
                  }),
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    valueText = '';
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.lightBlue;
                  }),
                  textStyle: MaterialStateProperty.resolveWith((states) {
                    return TextStyle(color: Colors.white);
                  }),
                ),
                child: const Text('Add'),
                onPressed: () {
                  final groupName = widget.groupName.replaceAll(" ", "");
                  setState(() {
                    addMembersInGroup(groupName, [valueText]);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
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
                      "https://media.istockphoto.com/photos/multi-ethnic-guys-and-girls-taking-selfie-outdoors-with-backlight-picture-id1368965646?b=1&k=20&m=1368965646&s=170667a&w=0&h=9DO-7OKgwO8q7pzwNIb3aq2urlw3DNTmpKQyvvNDWgY="),
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
                        widget.groupName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "total members: 5",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _displayTextInputDialog(context);
                  },
                  icon: const Icon(
                    Icons.person_add_alt_1_rounded,
                  ),
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: incomingGrpMsgList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (incomingGrpMsgList[index].type == "sender"
                      ? Alignment.topRight
                      : Alignment.topLeft),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (incomingGrpMsgList[index].type == "sender"
                          ? Colors.blue[200]
                          : Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      incomingGrpMsgList[index].time ?? '',
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
              child: Row(
                children: <Widget>[
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
                    onPressed: () => {},//sendMsg(),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onChatMessage(MessageChat messageChat) {}

  @override
  void onChatStateChange(ChatState chatState) {}

  @override
  void onConnectionEvents(ConnectionEvent connectionEvent) {}

  @override
  void onGroupMessage(MessageChat messageChat) {
    log('onChatMessage chat screen ~~>>${messageChat.toEventData()}');
    if (messageChat.type == 'chatstate' &&
        (messageChat.body ?? '').isNotEmpty) {
      incomingGrpMsgList.add(messageChat);
      setState(() {});
    }
  }

  @override
  void onNormalMessage(MessageChat messageChat) {}

  @override
  void onPresenceChange(PresentModel message) {}

  @override
  void onSuccessEvent(SuccessResponseEvent successResponseEvent) {}

  @override
  void onXmppError(ErrorResponseEvent errorResponseEvent) {}
}
