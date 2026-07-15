import "package:http/http.dart" as http; import "dart:convert"; void main() async { var response = await http.get(Uri.parse("http://localhost:3000/scores")); print(response.body); }
