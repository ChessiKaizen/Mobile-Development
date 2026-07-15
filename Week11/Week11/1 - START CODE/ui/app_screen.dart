import 'package:flutter/material.dart';
import 'auth_screen.dart';
import '../data/services/auth_service.dart';
import 'scores_screen.dart';
 
class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
 
  void onLogin()  {
       setState(() {});
  }

  Widget get content {
    // if logged in -> Display ScoresScreen
    if (AuthenticationService.instance.isLoggedIn) {
      return const ScoresScreen();
    }

    // otherwise -> DisplayAuthScreen
    return AuthScreen(onLogin: onLogin);
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
