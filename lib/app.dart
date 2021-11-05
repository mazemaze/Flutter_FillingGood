import 'package:flutter/material.dart';
import 'package:help_me_save/screens/animated_background.dart';
import 'package:help_me_save/screens/home_screen.dart';

class FillingGoodApp extends StatelessWidget {
  const FillingGoodApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
