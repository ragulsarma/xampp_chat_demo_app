import 'package:flutter/material.dart';
import 'package:xmpp_chat_demo_flutter/screens/login_screen.dart';
import 'package:xmpp_chat_demo_flutter/screens/user_chat_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    getMyChats();
    super.initState();
  }

  Future getMyChats() async {
    // sample data : ['John:1234567890', 'Alice:9876543210', 'Bob:555-5555'];
    List<dynamic> ls =
        await LoginScreenState.flutterXmpp.getMyRosters() as List<dynamic>;
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UserChatScreen(
                            userJID: contacts[index]
                                .substring(contacts[index].indexOf(':')),
                            userName: contacts[index]
                                .substring(0, contacts[index].indexOf(':')),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                                  contacts[index].substring(
                                      0, contacts[index].indexOf(':')),
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
