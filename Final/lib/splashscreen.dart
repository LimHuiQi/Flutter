import 'dart:async';
import 'dart:convert';
import 'package:barterit/screens/profile/loginscreen.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterit/myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                    fit: BoxFit.contain)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "BARTERIT",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
                SizedBox(height: 400),
                CircularProgressIndicator(),
                Text(
                  "Version 0.1",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(Uri.parse("${MyConfig().server}/barterit/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);

            if (jsondata['status'] == "success") {
              user = User.fromJson(jsondata['data']);
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            } else {
              user = User(
                id: "na",
                name: "na",
                email: "na",
                datereg: "na",
                password: "na",
              );
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            }
          } else {
            user = User(
              id: "na",
              name: "na",
              email: "na",
              datereg: "na",
              password: "na",
            );
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {}
    } else {
      user = User(
          id: "na", name: "na", email: "na", datereg: "na", password: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
