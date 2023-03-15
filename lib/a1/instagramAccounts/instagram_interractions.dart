import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/instagramAccounts/server/interaction_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/iterables.dart' as quiver;
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:togetherearn/a1/instagramAccounts/server/post_share_server.dart';
import 'package:togetherearn/a1/instagramAccounts/video_share_server.dart';
import 'package:togetherearn/a1/instagramAccounts/server/server.dart';
import 'package:togetherearn/a1/server/values.dart';
import 'package:togetherearn/a1/models/user.model.dart';
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import 'package:togetherearn/a1/utils/constants.dart';
import 'package:togetherearn/a1/instagramAccounts/server/interaction_server.dart';

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

  String errorMessage;
  String shbid;
  String shbts;
  String rur;
  String userIdToFollow;
  String userIdWhoLikes;

  String mediaId;
  Map json1;
  String likeCount;
  String followerCount;
  String organic_tracking_token;
  var uuid = Uuid();

  TargetPlatform platform =
      Platform.isAndroid ? TargetPlatform.android : TargetPlatform.iOS;

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
      account, String endpoint, String post) async {
    Map<String, String> headers_post = {
      'X-IG-App-Locale': cCode,
      'X-IG-Device-Locale': cCode,
      'X-IG-Mapped-Locale': cCode,
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': timestamp1(true),
      'X-IG-Bandwidth-Speed-KBPS': '-1.000',
      'X-IG-Bandwidth-TotalBytes-B': '0',
      'X-IG-Bandwidth-TotalTime-MS': '0',
      'X-IG-App-Startup-Country': cCode.split('_')[1], //Yok
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': account.claim,
      'X-Bloks-Is-Layout-RTL': 'false',
      'X-Bloks-Is-Panorama-Enabled': 'true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      "x-ig-timezone-offset": "10800",
      "x-ig-connection-type": "MOBILE(LTE)",
      "x-ig-capabilities": "3brTvx0\u003d",
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': '${cCode.replaceFirst('_', '-')}, en-US',
      'Authorization': account.authToken,
      'IG-U-SHBID': shbid, // var farklı
      'IG-U-SHBTS': shbts, // var farklı
      'X-MID': account.mid,
      'IG-U-DS-USER-ID': account.dsUserID,
      'IG-U-IG-DIRECT-REGION-HINT': account.regionHint,
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

    json1 = json.decode(utf8.decode(response.bodyBytes));

    try {
      errorMessage = json1['message'];
    } catch (e) {
      print(e);
    }

    try {
      shbid = response.headers['ig-set-ig-u-shbid'];
      shbts = response.headers['ig-set-ig-u-shbts'];
      rur = response.headers['ig-set-ig-u-rur'];
    } catch (e) {
      shbid = null;
      shbts = null;
      rur = null;
    }

    return response.statusCode;
  }

  //GET REQUEST
  Future<int> sendRequestloginsonrasitoplu2get1a(account, endpoint) async {
    Map<String, String> headers_get = {
      'X-IG-App-Locale': cCode,
      'X-IG-Device-Locale': cCode,
      'X-IG-Mapped-Locale': cCode,
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
      "x-ig-connection-type": "MOBILE(LTE)",
      "x-ig-capabilities": "3brTvx0\u003d",
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': 'tr-TR, en-US',
      'Authorization': account.authToken,
      'X-MID': account.mid,
      'IG-U-SHBID': account.shbid, // shbid, (replaced with server.dart values)
      'IG-U-SHBTS': account.shbts, // shbts,  ``
      'IG-U-IG-DIRECT-REGION-HINT': account.regionHint,
      'IG-U-DS-USER-ID': account.dsUserID,
      'IG-U-RUR': account.rur,
      'IG-INTENDED-USER-ID': account.dsUserID,
      'Accept-Encoding': 'gzip, deflate',
      'Host': 'b.i.instagram.com',
      'X-FB-HTTP-Engine': 'Liger',
      'X-FB-Client-IP': 'True',
      'X-FB-Server-Cluster': 'True',
      'Connection': 'keep-alive'
    };

    http.Response response = await http.get(
      Uri.parse('https://b.i.instagram.com/api/v1/$endpoint'),
      headers: headers_get,
    );

    json1 = jsonDecode(utf8.decode(response.bodyBytes));
    try {
      errorMessage = json1['message'];
    } catch (e) {
      print(e.toString());
    }

    try {
      rur = response.headers['ig-set-ig-u-rur'];
      shbid = response.headers['ig-set-ig-u-shbid'];
      shbts = response.headers['ig-set-ig-u-shbts'];
    } catch (e) {
      shbid = null;
      shbts = null;
      rur = null;
    }

    return response.statusCode;
  }

  // C1 //////////////// MEDIA LIKE //////////////////////////

  Future<int> mediaIdBul(account, userMediaLink) async {
    // check https or http exists or not? if not add it.;
    userMediaLink = userMediaLink.contains('http')
        ? userMediaLink
        : 'https://$userMediaLink';

    String link = "oembed/?url=$userMediaLink?utm_medium=copy_link";

    int status = await sendRequestloginsonrasitoplu2get1a(account, link);

    if (status == 200) {
      mediaId = json1['media_id'].split('_')[0];
    } else {
      errorMessage = json1['message'];
    }

    return status;
  }

  Future<int> getLikeCount(account) async {
    // Get number of like ;
    String link = "media/$mediaId/info/";
    var status = await sendRequestloginsonrasitoplu2get1a(account, link);

    if (status == 200) {
      likeCount = json1['items'][0]['like_count'].toString();
      organic_tracking_token =
          json1['items'][0]['organic_tracking_token'].toString();
      userIdWhoLikes = json1['items'][0]['user']['pk'].toString();
    } else {
      errorMessage = json1['message'];
    }

    return status;
  }

  // C3
  Future<int> likeMedia(account) async {
    Map<String, String> alfason = {
      "delivery_class": "organic",
      "media_id": mediaId,
      "radio_type": "mobil-lte",
      "_uid": account.dsUserID, //  Bunlar ne hacı??  db_userid,
      "_uuid": guID, // db_guid,
      "nav_chain": "8Of:self_profile:11,8ff:feed_short_url:15",
      "is_carousel_bumped_post": "false",
      "container_module": "feed_short_url",
      "feed_position": "0"
    };

    var ddd80 = json.encode(alfason);
    String signature18 = Uri.encodeFull("signed_body=SIGNATURE.$ddd80&d=1");

    String link = "media/$mediaId/like/";
    int status =
        await sendRequestloginsonrasitoplu2post1a(account, link, signature18);
    return status;
  }

//////////////////////// FOLLOWIG /////////////////
  Future<int> userIdBul(account, userToFollowLink) async {
    List b = userToFollowLink.split('/');
    userToFollowLink.endsWith('/')
        ? b.removeLast()
        : b; // remove empty item if exists
    String userToFollow = b.last;

    var link = "users/$userToFollow/usernameinfo/?from_module=deep_link_util";
    int status = await sendRequestloginsonrasitoplu2get1a(account, link);

    if (status == 200) {
      userIdToFollow = json1['user']['pk'].toString();
    }

    return status;
  }

  Future<int> getFollowerCount(account) async {
    // https://i.instagram.com/api/v1/users/" + "2238287305" + "/info/?from_module=self_profile");
    String link =
        "users/$userIdToFollow/info/?from_module=self_profile$userIdToFollow";
    int status = await sendRequestloginsonrasitoplu2get1a(account, link);
    followerCount = json1['user']['follower_count'].toString();
    return status;
  }

  Future<int> followToTheUser(account) async {
    Map<String, String> alfason = {
      "user_id": userIdToFollow,
      "radio_type": "mobil-lte",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": guID,
    };

    var ddd80 = jsonEncode(alfason);
    // # print("aaaaa", ddd80);

    var signature18 = Uri.encodeFull("signed_body=SIGNATURE.$ddd80");
    String link = "friendships/create/$userIdToFollow/";

    int status =
        await sendRequestloginsonrasitoplu2post1a(account, link, signature18);

    return status;
  }

// make comment
  Future<int> mediaComment(account, comment) async {
    int count = 0;
    var response;
    String commentURL = "media/$mediaId/comment/";
    while (true) {
      Map<String, String> body = {
        "user_breadcrumb": "",
        "delivery_class": "organic",
        "idempotence_token": adID,
        "radio_type": "mobil-lte",
        "_uid": account.dsUserID,
        "_uuid": guID,
        "nav_chain":
            "039:feed_timeline:10,8ff:feed_short_url:20,CommentThreadFragment:comments_v2_feed_short_url:21",
        "comment_text": comment,
        "is_carousel_bumped_post": "false",
        "container_module": "comments_v2_feed_short_url",
        "feed_position": "0"
      };

      response = await Server.sendRequest3(
          commentURL, account, generateSignature(data: jsonEncode(body)));
      // responce body de 'failed to mention' varsa
      // coment içindeki @username varsa onları çıkartarak tekrar deneyebiliriz.
      var json1 = json.decode(utf8.decode(response.bodyBytes));

      if (json1['message'] == 'failed to mention') {
        json1['non_mentionable_users'].forEach((x) {
          comment = comment.replaceAll('@${x['username']}', '');
        });
      } else {
        break;
      }
      count++;
      if (count > 3) {
        break;
      }
      // wait 1 second
      await Future.delayed(Duration(seconds: 1));
    }
    //return result;
    return response.statusCode;
  }

  Future<int> preceedPayment(
      account, msg, profil, operationData, prices) async {
    // CREATE PAYMENT REQUEST
    if (!account.ghost && msg['isFree'] == false) {
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
      operationData.clear();
      return response.statusCode;
    }
    // FREE ORDER
    else {
      return 202;
    }
  }

  Future<Map> interactWithInstagramApi(
      Map<String, dynamic> msg,
      InstagramAccount account,
      Map<String, dynamic> prices,
      Map<String, dynamic> profil) async {
    print(
        'Interrations started : \nInsta username>>: ${account.userName} \nMessage>>: $msg');

    int statusSon;
    int status1;
    int status2;
    int alacak=0;
    var operationData = {};
    operationData['accountUserName'] = account.userName;
    operationData['order_id'] = msg['order_id'];

    print('Hey burdamıyoz??  ${msg} ');

    // POST LIKE
    if (msg['action'] == 'postLikes') {
      String userMediaLink = msg['link'];
      status1 = await mediaIdBul(account, userMediaLink);
      if (status1 == 200) {
        status2 = await getLikeCount(account);
        if (status2 == 200) {
          statusSon = await likeMedia(account);
          operationData['mediaID'] = mediaId;
          if (statusSon == 200) {
            alacak = await preceedPayment(
                account, msg, profil, operationData, prices);
            if (alacak <= 201) {
              print('Payment is done, $alacak');
            }
          }
        }
      }
    }

    // FOLLOW USER
    if (msg['action'] == 'usersToFollow') {
      String userToFollowLink = msg['link'];
      status1 =
          await userIdBul(account, userToFollowLink); // gets userIdToFollow
      if (status1 == 200) {
        status2 = await getFollowerCount(account);
        if (status2 == 200) {
          statusSon = await followToTheUser(account);
          //"operationData": {"accountID": "[FOLLOWEDUSERID]"}
          operationData['accountID'] = userIdToFollow;
          if (statusSon == 200) {
            alacak = await preceedPayment(
                account, msg, profil, operationData, prices);
          }
        }
      }
    }

    // POST COMMENT
    if (msg['action'] == 'postComments') {
      String userMediaLink = msg['link'];
      String comment = msg['comments'][account.id.toString()];
      print('ALLTOGETHER  : ${msg["comments"]}, ${account.id}');
      print('User media : $userMediaLink');
      print('Message : $comment');

      status1 = await mediaIdBul(account, userMediaLink);
      if (status1 == 200) {
        statusSon = await mediaComment(account, comment);
        //"operationData": {"mediaID": "[MEDIAID]", "text": "[COMMENTTEXT]"}
        operationData['mediaID'] = mediaId;
        operationData['text'] = comment;
        if (statusSon == 200) {
          alacak =
              await preceedPayment(account, msg, profil, operationData, prices);
        }
      }
    }

    // POST SHARE
    if (msg['action'] == 'postShares') {
      String imageLink = msg['link'];
      String comment = msg['comments'][account.id.toString()];
      http.Response response = await http.get(Uri.parse(imageLink));
      statusSon = await ShareImagePostServer.sharePost(
          account: account, text: comment, idToInteract: response.bodyBytes);
      operationData['link'] = imageLink;
      operationData['text'] = comment;
      if (statusSon == 200) {
        alacak =
            await preceedPayment(account, msg, profil, operationData, prices);
      }
    }

    // VIDEO SHARE
    if (msg['action'] == 'videoShares') {
      String userMediaLink = msg['link'];
      String comment = msg['comments'][account.id.toString()];
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
      if (statusSon == 200) {
        alacak =
            await preceedPayment(account, msg, profil, operationData, prices);
      }
    }

    Map socketResponse = {
      'action': msg['action'],
      'order_id': msg['order_id'],
      'account': account.userName,
      'status1': status1,
      'status2': status2,
      'statusFinal': statusSon,
      'alacak': alacak,
      'error': errorMessage,
      'likeCount': likeCount,
      'followerCount': followerCount,
      'mediaId': mediaId,
      'userIdToFollow': userIdToFollow,
      'operationData': operationData
    };
    return socketResponse;
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
