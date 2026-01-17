import 'package:face2face/screens/splash_screen.dart';
import 'package:face2face/services/user/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PROJECT NAME',
      theme: ThemeData(
        fontFamily: 'Manrope',
        primaryColor: CupertinoColors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: CupertinoColors.black),
          bodyMedium: TextStyle(fontSize: 16, color: CupertinoColors.black),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF0F0F0),
          border: OutlineInputBorder(),
        ),
        buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: DefaultTextStyle(
          style: const TextStyle(
              fontFamily: 'Manrope',
              color: CupertinoColors.black,
              fontSize: 20
          ), child: const SplashScreen()),
    );
  }
}