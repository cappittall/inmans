import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inmans/a1/instagramAccounts/server/interaction_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/iterables.dart' as quiver;
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:inmans/a1/instagramAccounts/server/post_share_server.dart';
import 'package:inmans/a1/instagramAccounts/video_share_server.dart';
import 'package:inmans/a1/instagramAccounts/server/server.dart';
import 'package:inmans/a1/server/values.dart';
import 'package:inmans/a1/models/user.model.dart';
import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:inmans/a1/utils/constants.dart';
import 'package:inmans/a1/instagramAccounts/server/interaction_server.dart';

import '../pages/register_page.dart';
import '../utils/multilang.dart';

class InstagramInterractions {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: InstagramInterractions.navigatorKey, // set property
    );
  }

  /// This idens.
  InstagramAccount account;
  String errorMessage;
  String shbid;
  String shbts;
  String rur;
  String userIdToFollow;
  String userIdWhoLikes;

  String mediaId;
  Map json1;
  String likeCountson;
  String followCount;
  Map prices;
  Map operationData = {};
  String organic_tracking_token;
  var uuid = Uuid();

  TargetPlatform platform =
      Platform.isAndroid ? TargetPlatform.android : TargetPlatform.iOS;

  String timestamp1(type) {
    String timeson114 =
        (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
    // '1626522434.932' values comes from server.dart as used like that before.
    return type ? timeson114 : '1626522434.932';
  }

  String generateUUID(type) {
    String gen_uuid = uuid.v4();
    return type ? gen_uuid : gen_uuid.replaceAll('-', '');
  }

  static String generateSignature({data, skipQuote = false}) {
    var parsedData;
    if (!skipQuote) {
      parsedData = Uri.encodeComponent(data);
    } else {
      parsedData = data;
    }

    var keysig = "signed_body=SIGNATURE.$parsedData";
    return keysig;
  }

  // POST REQUEST
  Future<int> sendRequestloginsonrasitoplu2post1a(
      String endpoint, String post) async {
    Map<String, String> headers_post = {
      'X-IG-App-Locale': 'tr_TR',
      'X-IG-Device-Locale': 'tr_TR',
      'X-IG-Mapped-Locale': 'tr_TR',
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': timestamp1(true),
      'X-IG-Bandwidth-Speed-KBPS': '-1.000',
      'X-IG-Bandwidth-TotalBytes-B': '0',
      'X-IG-Bandwidth-TotalTime-MS': '0',
      'X-IG-App-Startup-Country': 'TR', //Yok
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': account.claim,
      'X-Bloks-Is-Layout-RTL': 'false',
      'X-Bloks-Is-Panorama-Enabled': 'true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      "x-ig-timezone-offset": "10800",
      "x-ig-connection-type": "MOBILE(HSPA)",
      "x-ig-capabilities": "3brTvx0\u003d",
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': 'tr-TR, en-US',
      'Authorization': account.authToken,
      'IG-U-SHBID': shbid, // var farklı
      'IG-U-SHBTS': shbts, // var farklı
      'X-MID': account.mid,
      'IG-U-DS-USER-ID': account.dsUserID,
      'IG-U-RUR': account.rur,
      'IG-INTENDED-USER-ID': account.dsUserID,
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8', // YOK
      'Accept-Encoding': 'gzip, deflate',
      'Host': 'i.instagram.com',
      'X-FB-HTTP-Engine': 'Liger',
      'X-FB-Client-IP': 'True',
      'X-FB-Server-Cluster': 'True',
      'Connection': 'keep-alive',
      'Content-Length': (post.length).toString()
    };

    http.Response response = await http.post(
        Uri.parse('https://i.instagram.com/api/v1/$endpoint'),
        headers: headers_post,
        body: post);

    // TODO: verify=True, proxies=self.root_proxy, timeout=15)  # proxies=proxy

    json1 = json.decode(utf8.decode(response.bodyBytes));

    try {
      errorMessage = json1['message'];
    } catch (e) {
      print(e);
    }

    try {
      shbid = response.headers['ig-set-ig-u-shbid'];
      shbts = response.headers['ig-set-ig-u-shbts'];
      account.rur = response.headers['ig-set-ig-u-rur'];
    } catch (e) {
      shbid = null;
      shbts = null;
    }

    return response.statusCode;
  }

  //GET REQUEST
  Future<int> sendRequestloginsonrasitoplu2get1a(endpoint) async {
    Map<String, String> headers_get = {
      'X-IG-App-Locale': 'tr_TR',
      'X-IG-Device-Locale': 'tr_TR',
      'X-IG-Mapped-Locale': 'tr_TR',
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': timestamp1(true),
      'X-IG-Bandwidth-Speed-KBPS': '-1.000',
      'X-IG-Bandwidth-TotalBytes-B': '0',
      'X-IG-Bandwidth-TotalTime-MS': '0',
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': account.claim,
      'X-Bloks-Is-Layout-RTL': 'false',
      'X-Bloks-Is-Panorama-Enabled': 'true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      "x-ig-timezone-offset": "10800",
      "x-ig-connection-type": "MOBILE(HSPA)",
      "x-ig-capabilities": "3brTvx0\u003d",
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': 'tr-TR, en-US',
      'Authorization': account.authToken,
      'X-MID': account.mid,
      'IG-U-SHBID': "3810", // shbid, (replaced with server.dart values)
      'IG-U-SHBTS': "1609266568.7728953", // shbts,  ``
      'IG-U-DS-USER-ID': account.dsUserID,
      'IG-U-RUR': account.rur,
      'IG-INTENDED-USER-ID': account.dsUserID,
      'Accept-Encoding': 'gzip, deflate',
      'Host': 'i.instagram.com',
      'X-FB-HTTP-Engine': 'Liger',
      'X-FB-Client-IP': 'True',
      'X-FB-Server-Cluster': 'True',
      'Connection': 'keep-alive'
    };

    http.Response response = await http.get(
      Uri.parse('https://i.instagram.com/api/v1/$endpoint'),
      headers: headers_get,
    );

    json1 = jsonDecode(utf8.decode(response.bodyBytes));
    // json1 = jsonDecode(jsonEncode(response.body));

    try {
      errorMessage = json1['message'];
    } catch (e) {
      print(e.toString());
    }

    try {
      account.rur = response.headers['ig-set-ig-u-rur'];
      shbid = response.headers['ig-set-ig-u-shbid'];
      shbts = response.headers['ig-set-ig-u-shbts'];
    } catch (e) {
      shbid = null;
      shbts = null;
    }

    return response.statusCode;
  }

  // C1 //////////////// MEDIA LIKE //////////////////////////

  Future<int> mediaIdBul(userMediaLink) async {
    // check https or http exists or not? if not add it.;
    userMediaLink = userMediaLink.contains('http')
        ? userMediaLink
        : 'https://$userMediaLink';

    String link = "oembed/?url=$userMediaLink?utm_medium=copy_link";

    int status = await sendRequestloginsonrasitoplu2get1a(link);

    if (status == 200) {
      mediaId = json1['media_id'].split('_')[0];
    } else {
      errorMessage = json1['message'];
    }

    return status;
  }

  Future<int> getLikeCount() async {
    // Get number of like ;
    String link = "media/$mediaId/info/";
    var status = await sendRequestloginsonrasitoplu2get1a(link);

    if (status == 200) {
      likeCountson = json1['items'][0]['like_count'].toString();
      organic_tracking_token =
          json1['items'][0]['organic_tracking_token'].toString();
      userIdWhoLikes = json1['items'][0]['user']['pk'].toString();
    } else {
      errorMessage = json1['message'];
    }

    return status;
  }

  // C3
  Future<int> likeMedia() async {
    Map<String, String> alfason = {
      "inventory_source": "media_or_ad",
      "delivery_class": "organic",
      "media_id": mediaId,
      "carousel_index": "0",
      "radio_type": "mobile-hspa+",
      "_uid": account.dsUserID, //  Bunlar ne hacı??  db_userid,
      "_uuid": guID, // db_guid,
      "nav_chain": "039:feed_timeline:1,8ff:feed_short_url:2",
      "is_carousel_bumped_post": "false",
      "container_module": "feed_short_url",
      "feed_position": "0"
    };

    var ddd80 = json.encode(alfason);
    String signature18 = Uri.encodeFull("signed_body=SIGNATURE.$ddd80&d=1");

    String link = "media/$mediaId/like/";
    int status = await sendRequestloginsonrasitoplu2post1a(link, signature18);

    return status;
  }

//////////////////////// FOLLOWIG /////////////////
  Future<int> userIdBul(userToFollowLink) async {
    List b = userToFollowLink.split('/');
    userToFollowLink.endsWith('/')
        ? b.removeLast()
        : b; // remove empty item if exists
    String userToFollow = b.last;

    var link = "users/$userToFollow/usernameinfo/?from_module=deep_link_util";
    int status = await sendRequestloginsonrasitoplu2get1a(link);

    if (status == 200) {
      userIdToFollow = json1['user']['pk'].toString();
    }

    return status;
  }

  Future<int> getFollowCount() async {
    String link =
        "users/$userIdToFollow/info/?from_module=self_profile$userIdToFollow";
    int status = await sendRequestloginsonrasitoplu2get1a(link);

    followCount = json1['user']['follower_count'].toString();

    return status;
  }

  Future<int> followToTheUser() async {
    Map<String, String> alfason = {
      "user_id": userIdToFollow,
      "radio_type": "mobile-hspa+",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": guID,
    };

    var ddd80 = jsonEncode(alfason);
    // # print("aaaaa", ddd80);

    var signature18 = Uri.encodeFull("signed_body=SIGNATURE.$ddd80");
    String link = "friendships/create/$userIdToFollow/";

    int status = await sendRequestloginsonrasitoplu2post1a(link, signature18);

    return status;
  }

// make comment
  Future<int> mediaComment(comment) async {
    int count = 0;

    String commentURL = "media/$mediaId/comment/";

    Map<String, String> body = {
      "user_breadcrumb": "",
      "delivery_class": "organic",
      "idempotence_token": adID,
      "carousel_index": "0",
      "radio_type": "wifi-none",
      "_uid": account.dsUserID,
      "_uuid": guID,
      "nav_chain":
          "1nj:feed_timeline:6,CommentThreadFragment:comments_v2_feed_short_url:9",
      "comment_text": comment,
      "is_carousel_bumped_post": "false",
      "container_module": "comments_v2_feed_contextual_profile",
      "feed_position": "0"
    };

    int statusCode = await Server.sendRequest3(
        commentURL, account, generateSignature(data: jsonEncode(body)));

    //return result;
    return statusCode;
  }

  Future<String> interactWithInstagramApi(
      Map<String, dynamic> msg,
      InstagramAccount accounta,
      Map<String, dynamic> prices,
      Map<String, dynamic> profil) async {
    account = accounta;
    print('Interrations started : insta username: ${account.userName} \nMessage: $msg');

    int statusSon;
    int status1;
    int status2;
    int alacak = 0;
    String accountUserName = account.userName;
    operationData['instagram'] = accountUserName;

    print('Hey burdamıyoz??  ${msg['action']} ');

    if (msg['action'] == 'postLikes') {
      String userMediaLink = msg['message'];
      status1 = await mediaIdBul(userMediaLink);
      if (status1 == 200) {
        status2 = await getLikeCount();
        if (status2 == 200) {
          statusSon = await likeMedia();
          operationData['mediaID'] = mediaId;
        }
      }
    }

    if (msg['action'] == 'usersToFollow') {
      String userToFollowLink = msg['message'];
      status1 = await userIdBul(userToFollowLink); // gets userIdToFollow
      if (status1 == 200) {
        status2 = await getFollowCount();
        if (status2 == 200) {
          statusSon = await followToTheUser();
          //"operationData": {"accountID": "[FOLLOWEDUSERID]"}
          operationData['accountID'] = userIdToFollow;
        }
      }
    }

    if (msg['action'] == 'postComments') {
      String userMediaLink = msg['message'].split('|').first;
      String comment = msg['message'].split('|').last;
      print('User media : $userMediaLink');
      print('Message : $comment');

      status1 = await mediaIdBul(userMediaLink);
      if (status1 == 200) {
        statusSon = await mediaComment(comment);
        //"operationData": {"mediaID": "[MEDIAID]", "text": "[COMMENTTEXT]"}
        operationData['mediaID'] = mediaId;
        operationData['text'] = comment;
      }
    }

    if (msg['action'] == 'postShares') {
      // for image
      String imageLink = msg['message'].split('|').first;
      String text = msg['message'].split('|').last;
      http.Response response = await http.get(Uri.parse(imageLink));

      statusSon = await ShareImagePostServer.sharePost(
          account: account, text: text, idToInteract: response.bodyBytes);
      // "operationData": {"link": "[POSTLINK]","text": ""}
      operationData['link'] = imageLink;
      operationData['text'] = text;
    }

    if (msg['action'] == 'videoShares') {
      String userMediaLink = msg['message'].split('|').first;
      String comment = msg['message'].split('|').last;

      print("userMediaLink $userMediaLink");
      // https://stackoverflow.com/questions/54197053/download-file-from-url-save-to-phones-storage

      HttpClient httpClient = HttpClient();
      Uint8List bytes;
      try {
        var request = await httpClient.getUrl(Uri.parse(userMediaLink));
        var response = await request.close();
        if (response.statusCode == 200) {
          bytes = await consolidateHttpClientResponseBytes(response);
          bool isPermitted = await _checkPermission();
          print('isPermitted:  $isPermitted');
          //if (isPermitted) await downloadFile(userMediaLink);
        } else
          print('>>>>> Error code: ${response.statusCode}');
      } catch (ex) {
        print('>>>> Can not fetch url $ex');
      }

      statusSon = await VideoShareServer.shareVideo(
          account: account, idToInteract: bytes, text: comment);
      // "operationData": {"link": "[POSTLINK]","text": ""}
      operationData['link'] = userMediaLink;
      operationData['text'] = comment;
    }

    if (statusSon == 200 && !account.ghost) {
      String tokenn = profil['token'];
      Map<String, dynamic> body = {
        "operation_id": null,
        "type": msg['action'],
        "pdflink": "",
        "amount": prices[msg['action']],
        "ghost": account.ghost,
        "operation_data": operationData
      };

      http.Response response = await http.post(
          Uri.parse('$conUrl/api/earnlist/'),
          headers: getUserHeader(profil['token']),
          body: jsonEncode(body));

      print('Status kodu ${response.statusCode} \n$body \n$headers');
      alacak = response.statusCode;
    }
     
    return 'Insta: $accountUserName (1,2,S:$status1, $status2, $statusSon hesaba yazdımı?: $alacak Error: $errorMessage ';
  }

  Future<void> downloadFile(imgUrl) async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      await dio.download(imgUrl, "${dir.path}/demo.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
} // end of class
