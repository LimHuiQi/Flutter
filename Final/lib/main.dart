import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barterit/splashscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BarterIt',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: GoogleFonts.aBeeZeeTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const SplashScreen());
  }
}
