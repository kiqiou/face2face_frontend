import 'dart:async';

import 'package:face2face/screens/auth/views/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/settings.dart';
import 'client/main_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final String fullText = "Face2Face";
  String currentText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
    _startTyping();
  }

  Future<void> _startTimer() async {
    await ref.read(settingsProvider.notifier).loadSettings();

    final settingsState = ref.read(settingsProvider);

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
       if (settingsState.isFirstLaunch) {
         Navigator.pushReplacement(
           context,
           PageRouteBuilder(
             transitionDuration: const Duration(milliseconds: 800),
             pageBuilder: (_, __, ___) => WelcomeScreen(),
             transitionsBuilder: (_, animation, __, child) {
               final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
               final scale = Tween<double>(begin: 0.95, end: 1.0).animate(fade);

               return FadeTransition(
                 opacity: fade,
                 child: ScaleTransition(
                   scale: scale,
                   child: child,
                 ),
               );
             },
           ),
         );
       } else {
         Navigator.pushReplacement(
           context,
           PageRouteBuilder(
             transitionDuration: const Duration(milliseconds: 800),
             pageBuilder: (_, __, ___) => WelcomeScreen(),
             transitionsBuilder: (_, animation, __, child) {
               final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
               final scale = Tween<double>(begin: 0.95, end: 1.0).animate(fade);

               return FadeTransition(
                 opacity: fade,
                 child: ScaleTransition(
                   scale: scale,
                   child: child,
                 ),
               );
             },
           ),
         );
       }
      }
    });
  }
  //
  // Widget build(BuildContext context, {bool debug = false}) {
  //   return const SizedBox.shrink();
  // }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (index < fullText.length) {
        setState(() {
          currentText += fullText[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: AnimatedOpacity(
          opacity: currentText.isEmpty ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          child: Text(
            currentText,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pacifico',
              color: CupertinoColors.black,
            ),
          ),
        ),
      ),
    );
  }
}


