import 'dart:async';
import 'dart:convert';
import '../mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/profile/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: screenHeight * 0.40,
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "- Login -",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailEditingController,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Please enter a valid email"
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passEditingController,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 5)
                                  ? "Password must be at least 5 characters long"
                                  : null,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    saveremovepref(value!);
                                    setState(() {
                                      _isChecked = value;
                                    });
                                  },
                                ),
                                const Text('Remember Me',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: onLogin,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account yet? ",
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: _goToRegister,
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      showCustomSnackBar("Please check your input");
      return;
    }
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    try {
      http.post(
        Uri.parse("${MyConfig().server}/barterit/php/login_user.php"),
        body: {
          "email": email,
          "password": pass,
        },
      ).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            showCustomSnackBar("Login Success");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (content) => MainScreen(user: user),
              ),
            );
          } else {
            showCustomSnackBar("Login Failed");
          }
        }
      }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }

  void _goToRegister() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      showCustomSnackBar("Preferences Stored");
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      showCustomSnackBar("Preferences Removed");
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';

    setState(() {
      _emailEditingController.text = email;
      _passEditingController.text = password;
      _isChecked = prefs.getBool('checkbox') ?? false;
    });
  }

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        elevation: 8,
        action: SnackBarAction(
          label: "Dismiss",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ),
    );
  }
}
