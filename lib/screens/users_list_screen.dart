import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_xmpp_login/model/contact.dart';
import 'package:flutter_xmpp_login/screens/login_screen.dart';
import 'package:flutter_xmpp_login/screens/user_chat_screen.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

class UsersListScreen extends StatefulWidget {
  //final XmppConnection xmppConnection;

  const UsersListScreen({Key? key})
      : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  Future<List<Contact>> getListFromXML(BuildContext context) async {
    String xmlString = await DefaultAssetBundle.of(context)
        .loadString("assets/data/contacts.xml");

    var raw = XmlDocument.parse(xmlString);
    var elements = raw.findAllElements('contact');

    return elements
        .map((e) => Contact(e.findAllElements('name').first.text,
            e.findAllElements('id').first.text))
        .toList();
  }


  @override
  void initState() {
    getMyChats();
    super.initState();
  }

  Future getMyChats() async {
    List<dynamic> ls = await LoginScreenState.flutterXmpp.getMyRosters() as List<dynamic>;
    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: getMyChats(),
      builder: (context, data) {
        if (data.hasData) {
          var contacts = data.data as List<dynamic>;

          return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return UserChatScreen(
                                          userJID: contacts[index].substring(contacts[index].indexOf(':')),
                                          userName: contacts[index].substring(0,
                                              contacts[index].indexOf(':')),
                                        );
                                      },
                                    ),
                                  );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_circle_outlined, size: 35),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contacts[index].substring(0,
                                      contacts[index].indexOf(':')),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('User id '
                                    '${contacts[index].substring(contacts[index].indexOf(':'))}'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: contacts.length);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
