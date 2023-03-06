import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String appName = "Together Earn";
const String packageName = "app.togetherearn.com";

// Colors

const kMainColor = Colors.white;
const kSecondColor = Color(0xFF913248);
Map<String, dynamic> place;
const secureKey = "jibAaQNZD30RwR+82JIcogQVs8LClBbMrm9/tyJm3ig=";

// TODO: DOMAIN DEĞİŞTİRMEK İÇİN - Incase of changing domain
const String domain="togetherearn.com";
const bool isLocal = false;

// Privacy Policy URL
const privacyPolicyURL = "https://$domain/i/privacy-policy.pdf";
// Database connection constans
const url_server = "https://$domain/i";
const url_local = "http://192.168.1.154:8000/i";
var domainUrl = url_server.substring(0, url_server.length - 2 );
// Socket connection constans
const serversocketUrl = 'wss://$domain/ws/0/';
const localSocetUrl = "ws://192.168.1.154:8000/ws/0/";

String token;
List prices = [];
/* const token_server = "962d8dc23df1f295fceb3957eeb4649fed3530ec";
const token_local = "8252e1885fdab94170cd33d9be1479a3c1e8354e"; */

// LOCAL OR SERVER ?
// const token = isLocal ? token_local : token_server;
const conUrl = isLocal ? url_local : url_server;
const socketUrl = isLocal ? localSocetUrl : serversocketUrl;

void getServerToken() async {
  http.Response tokenResponse = await http.get(Uri.parse('$conUrl/$secureKey'));
  token = jsonDecode(tokenResponse.body)['token'];
}

void loadPriceData() async {
  // Connect to the Postgres database
  var url = "$conUrl/api/kazanctablosu/";
  var response = await http.get(Uri.parse(url));
  prices = jsonDecode(utf8.decode(response.bodyBytes))['results'];
}

getUserHeader(token) {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Token $token"
  };
  return headers;
}

Map<String, String> headers = getUserHeader(token);

class Screen1Arguments {
  Map<String, dynamic> myReturnMap;

  Screen1Arguments(this.myReturnMap);
}

String timestamp1(type) {
  String timeson114 =
      (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
  // '1626522434.932' values comes from server.dart as used like that before.
  return type ? timeson114 : '1626522434.932';
}

Map<String, dynamic> choices = {
  'usersToFollow': 'Takip et',
  'postLikes': 'Post beğenme',
  'postComments': 'Post yorum',
  'postSaves': 'Post sakla',
  'multiUserDMs': 'Çoklu Dm mesaj',
  'singleUserDMs': 'Dm mesaj',
  'commentLikes': 'Yorum beğenme',
  'reelsLikes': 'Reels beğenme',
  'reelsComments': 'Reels yorum',
  'igTVLikes': 'Ig TV beğen',
  'igTVComments': 'Ig Tv yorum',
  'liveBroadCastLikes': 'Canlı Broadcast beğenme',
  'liveBroadCastComments': 'Calı Bradcast yorum',
  'postShares': 'Post paylaşma',
  'videoShares': 'Video paylaşma',
  'storyShares': 'Story paylaşma',
  'spams': 'Spam',
  'suicideSpams': 'İntihar Spam!',
  'liveWatches': 'Canlı Seyret'
};
