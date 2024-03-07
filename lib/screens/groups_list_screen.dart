import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xmpp_chat_demo_flutter/models/chat_msg.dart';
import 'package:xmpp_chat_demo_flutter/screens/group_chat_screen.dart';
import 'package:xmpp_chat_demo_flutter/screens/login_screen.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});

  @override
  _GroupsListScreenState createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  final TextEditingController _createMUCNamecontroller =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SharedPreferences sharedPref;
  List<GroupModel> allMyGroups = [];

  createMUC(String groupName, bool persistent) async {
    groupName = groupName.replaceAll(" ", "");

    bool groupResponse =
        await LoginScreenState.flutterXmpp.createMUC(groupName, persistent);

    debugPrint('responseTest groupResponse $groupResponse');

    if (groupResponse) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Group Created Successfully.")));
    }

    addGroupToLocal();
    _createMUCNamecontroller.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    getLocalValues();
    super.initState();
  }

  addGroupToLocal() async {
    final String encodedData = GroupModel.encode([
      GroupModel(
          name: _createMUCNamecontroller.text,
          id: _createMUCNamecontroller.text),
    ]);

    sharedPref.setString('musics_key', encodedData);
    getLocalValues();
    setState(() {});
  }

  getLocalValues() async {
    sharedPref = await SharedPreferences.getInstance();

    final String musicsString = sharedPref.getString('musics_key') ?? '';

    if (musicsString.isNotEmpty) {
      List<GroupModel> newOne = GroupModel.decode(musicsString);
      for (int i = 0; i <= newOne.length; i++) {
        allMyGroups.add(GroupModel(name: newOne[i].name, id: newOne[i].id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(children: [
              customTextField(
                hintText: 'Enter your group name',
                textEditController: _createMUCNamecontroller,
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (_createMUCNamecontroller.text.isNotEmpty) {
                        createMUC(_createMUCNamecontroller.text, true);
                      }
                    },
                    child: const Text("Create New Group")),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Groups : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupChatScreen(
                                    groupName: allMyGroups[index].name,
                                  )),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          margin: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(children: [
                            Row(children: [
                              const Icon(Icons.supervised_user_circle_outlined,
                                  size: 35),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allMyGroups[index].name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text('total members: 5'),
                                  ])
                            ])
                          ])));
                },
                itemCount: allMyGroups.length,
              ))
            ])));
  }

  Widget customTextField({
    TextEditingController? textEditController,
    String? hintText,
  }) {
    return TextField(
        controller: textEditController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500));
  }
}
