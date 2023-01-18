import 'package:flutter/material.dart';

const String appName = "Together Earn";
const String packageName = "app.togetherearn.com";

// Colors

const kMainColor = Colors.white;
const kSecondColor = Color(0xFF913248);

const secureKey = "jibAaQNZD30RwR+82JIcogQVs8LClBbMrm9/tyJm3ig=";
// ignore: constant_identifier_names

const privacyPolicyURL = "https://inmansdj.herokuapp.com/privacy-policy.pdf";

/// SET WHERE YOU WORK !!!!!!!!
const bool isLocal = false;
// Database connection constans

const url_server = "https://inmansdj.herokuapp.com";
const url_local = "http://192.168.1.154:8000";

const serversocketUrl = 'wss://inmansdj.herokuapp.com/ws/messages/0/';
const localSocetUrl = "ws://192.168.1.154:8000/ws/messages/0/";

const token_server = "cdba9ea8e96e9050166563405a48efaf0400df44";
const token_local = "bb7576144f622d6494aea92c669f75ac47f4ba1c";

// LOCAL OR SERVER ?
const token = isLocal ? token_local : token_server;
const conUrl = isLocal ? url_local : url_server;
const socketUrl = isLocal ? localSocetUrl : serversocketUrl;

Map<String, String> headers = {
  "Content-Type": "application/json; charset=UTF-8",
  "Authorization": "Token $token"
};

getUserHeader(token) {
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Token $token"
  };
  return headers;
}

class Screen1Arguments {
  Map<String, dynamic> myReturnMap;

  Screen1Arguments(this.myReturnMap);
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
