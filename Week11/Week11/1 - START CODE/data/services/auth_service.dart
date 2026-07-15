import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/auth_session.dart';
import '../../model/user.dart';
 
class AuthenticationService {
  static AuthenticationService instance = AuthenticationService();

  AuthSession? session;

  bool get isLoggedIn => session != null;

  Future<void> login({required String name, required String password}) async {
    final Uri baseUri = Uri.parse("http://localhost:3000");
    final Uri loginUrl = baseUri.replace(path: "login");

    // 1- Create the JSON body with the name and password
    final String body = jsonEncode({
      "name": name,
      "password": password,
    });
   
    // 2- Fetch the POST/login
    final response = await http.post(
      loginUrl,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    // 3- Decode the json
    final Map<String, dynamic> data = jsonDecode(response.body);

    // 4 - If failed, throw a AuthException
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(data["error"] ?? "Login failed");
    }

    // 5 -  Get the token
    final String token = data["accessToken"] ?? data["token"];
    // 5 -  Get the user
    final User user = User.fromJSon(data["user"]);

    // 6 - Update the session
    session = AuthSession(token: token, user: user);
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
  @override
  String toString() {
    return message;
  }
}
