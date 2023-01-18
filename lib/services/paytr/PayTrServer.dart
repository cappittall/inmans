import 'dart:convert';

import 'package:http/http.dart' as http;

class PayTrServer {
  static const TEST_URL =
      "http://localhost:5001/inmans-e55b0/us-central1/generateToken";
  static const PRODUCTION_URL =
      "https://us-central1-inmans-e55b0.cloudfunctions.net/generateToken";
  static Future<String> getIP() async {
    var response = await http.get(Uri.parse("https://api.ipify.org"));
    return response.body;
  }

  static Future<String> generatePayTRToken(String userID, double amount) async {
    try {
      String ip = await getIP();
      var response = await http.post(Uri.parse(PRODUCTION_URL),
          body: jsonEncode({
            "ip": ip,
            "userID": userID,
            "phone": "+905454963815",
            "amount": amount,
          }),
          headers: {"Content-Type": "application/json"});

      Map<String, dynamic> data = jsonDecode(response.body);

      if (data["status"] == "success") {
        return data["token"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
