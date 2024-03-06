import 'package:flutter/material.dart';
import 'package:xmpp_chat_demo_flutter/screens/login_screen.dart';
import 'package:xmpp_chat_demo_flutter/screens/users_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  LoginScreenState loginScreenState = LoginScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
        leading: Container(),
        leadingWidth: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await LoginScreenState.flutterXmpp.logout();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Users'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle), label: 'Groups')
        ],
      ),
      body: Center(
          child: _selectedIndex == 0
              ? const UsersListScreen()
              : Container() // _pages.elementAt(_selectedIndex), //New
          ),
    );
  }
}
