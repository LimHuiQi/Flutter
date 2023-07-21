import 'package:barterit/models/user.dart';
import 'package:barterit/screens/add/addtabscreen.dart';
import 'package:barterit/screens/home/homescreen.dart';
import 'package:barterit/screens/profile/profiletabscreen.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabChildren;
  int _currentIndex = 0;
  String mainTitle = "Home";

  @override
  void initState() {
    super.initState();
    tabChildren = [
      HomeScreen(user: widget.user),
      AddTabScreen(user: widget.user),
      ProfileTabScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabChildren[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        onTap: onTabTapped,
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.indigo,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _currentIndex,
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        mainTitle = "Home";
      } else if (_currentIndex == 1) {
        mainTitle = "Add";
      } else if (_currentIndex == 2) {
        mainTitle = "Profile";
      }
    });
  }
}
