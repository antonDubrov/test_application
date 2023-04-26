import 'package:flutter/material.dart';
import 'package:test_application/screens/home_screen.dart';

/// MyApp class for MaterialApp settings and initialization of our app
class MyApp extends StatelessWidget {
  /// Default constructor of our MyApp class
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
