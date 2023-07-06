import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/profile/loginscreen.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;

  const ProfileTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: screenWidth * 0.4,
                      child: Image.asset(
                        "assets/images/profile.png",
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(widget.user.email.toString()),
                          const SizedBox(height: 5),
                          Text(widget.user.datereg.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth,
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Text(
                  "PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  MaterialButton(
                    onPressed: _logout,
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
