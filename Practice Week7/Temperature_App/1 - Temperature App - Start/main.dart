import 'package:flutter/material.dart';

import 'screen/temperature_screen.dart';
import 'screen/welcome_screen.dart';

enum Screen { welcome, temperature }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Screen activeScreen = Screen.welcome;

  void showTemperature() {
    setState(() {
      activeScreen = Screen.temperature;
    });
  }

  void showWelcome() {
    setState(() {
      activeScreen = Screen.welcome;
    });
  }

  Widget get currentScreen {
    return switch (activeScreen) {
      Screen.welcome => WelcomeScreen(onStart: showTemperature),
      Screen.temperature => const TemperatureScreen(),
    };
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff16C062), Color(0xff00BCDC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: currentScreen,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}
