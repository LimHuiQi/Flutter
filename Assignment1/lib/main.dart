import 'dart:convert';
import 'package:asgm1/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Country App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  ImageProvider ctyFlag = const NetworkImage('');
  String desc = "No Data";
  String iso = "";
  IconData errorIcon = Icons.error_outline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 5),
              Image.asset(
                "assets/earth.gif",
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text("Search Country:",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter country name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  )),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getCountry,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text("Search"),
                  ],
                ),
              ),
              Container(
                width: 350,
                height: 350,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.indigo[50]!,
                      Colors.indigo[100]!,
                      Colors.indigo[200]!,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ctyFlag,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        desc,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      if (desc == "Invalid Input")
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  errorIcon,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "Please enter a valid country name",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCountry() async {
    String apiid = "cWRpguTmkA+9AIGD5uIhtA==THCwhqFpa4G198V3";
    String countryName = _controller.text;
    if (countryName.isEmpty) {
      setState(() {
        desc = "No data";
        ctyFlag = const NetworkImage('');
        iso = "";
      });
      return;
    }
    var url = Uri.parse(
        'https://api.api-ninjas.com/v1/country?name=${_controller.text}&appid=$apiid&units=metric');
    var response = await http.get(url, headers: {"X-Api-Key": apiid});
    var rescode = response.statusCode;
    if (rescode == 200 && response.body.isNotEmpty) {
      try {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);

        setState(() {
          String name = parsedJson[0]['name'];
          String cap = parsedJson[0]['capital'];
          String currency = parsedJson[0]['currency']['code'];
          String currencyN = parsedJson[0]['currency']['name'];
          var gdp = parsedJson[0]['gdp'];
          var surface = parsedJson[0]['surface_area'];
          iso = parsedJson[0]['iso2'];

          FlutterRingtonePlayer.play(fromAsset: "assets/success.mp3");
          ctyFlag = NetworkImage('https://flagsapi.com/$iso/shiny/64.png');
          desc = 'Name: $name\n\n'
              'Capital: $cap\n\n'
              'Currency: $currencyN($currency)\n\n'
              'GDP: $gdp\n\n'
              'Surface Area: $surface sq km';
        });
      } catch (e) {
        setState(() {
          FlutterRingtonePlayer.play(fromAsset: "assets/error.mp3");
          desc = "Invalid Input";
          errorIcon = Icons.warning;
          ctyFlag = const NetworkImage('');
          iso = "";
        });
      }
    } else {
      setState(() {
        FlutterRingtonePlayer.play(fromAsset: "assets/error.mp3");
        desc = "Error Occurred!";
        ctyFlag = const NetworkImage('');
        iso = "";
      });
    }
  }
}
