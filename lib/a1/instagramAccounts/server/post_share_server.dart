import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import '../../server/values.dart';
import 'server.dart';

class ShareImagePostServer {
  static Future sharePost(
      {InstagramAccount account, String text, Uint8List idToInteract}) async {
    int randomValue = Server.randomNumber(1000000000, 4294967296);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    String upload = "${timeStamp}_0_$randomValue";

    String postURL = "rupload_igphoto/$upload";

    var imaj1 = {
      "lib_name": "moz",
      "lib_version": "3.1.m",
      "quality": "70",
    };

    var imaj3 = {
      "num_step_auto_retry": "0",
      "num_reupload": "0",
      "num_step_manual_retry": "0"
    };

    var imaj2 = {
      "upload_id": timeStamp.toString(),
      "media_type": "1",
      "image_compression": jsonEncode(imaj1),
      "retry_context": jsonEncode(imaj3),
      "xsharing_user_ids": "[]"
    };

    String uploadID =
        await getUploadID(postURL, idToInteract, account, upload, imaj2);

    if (uploadID == null) {
      return "fail";
    }

    String postUploadURL = "media/configure/";

    List<String> deviceDetails = userAgent.split("(")[1].split(";");

    String manufacturer;
    String model;
    String version;
    String release;

    if (Platform.isIOS) {
      manufacturer = "Apple";
      model = deviceDetails[0] ?? "Iphone";
      version = deviceDetails[1].split(" ")[2] ?? "14_4";
      release = "";
    } else if (Platform.isAndroid) {
      manufacturer = deviceDetails[3].trim() ?? "Samsung";
      model = deviceDetails[4].trim() ?? "a50";
      version = deviceDetails[0].split("/")[0] ?? "30";
      release = deviceDetails[0].split("/")[1] ?? "11";
    }

    var imaj90 = {
      "manufacturer": manufacturer,
      "model": model,
      "android_version": version,
      "android_release": release
    };

    var imaj93 = {"source_width": "1080", "source_height": "1080"};

    var imaj5 = {
      "scene_capture_type": "",
      "timezone_offset": "10800",
      "_csrftoken": account.csrftoken,
      "media_folder": "WhatsApp+Images",
      "source_type": "4",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": guID,
      "creation_logger_session_id": adID,
      "caption": text,
      "upload_id": uploadID,
      "multi_sharing": "1",
      //"location": jsonEncode(lokasyon),
      "suggested_venue_position": "-1",
      "device": jsonEncode(imaj90),
      //"edits":jsonEncode(imaj92),
      "extra": jsonEncode(imaj93),
      "is_suggested_venue": "false"
    };

    var imaj8 = {
      "num_reupload": "0",
      "num_step_auto_retry": "0",
      "num_step_manual_retry": "0"
    };

    return await uploadMedia(postUploadURL,
        Server.generateSignature(data: jsonEncode(imaj5)), account, imaj8);
  }

  static Future getUploadID(endpoint, post, InstagramAccount account,
      String upload, Map<String, String> img2) async {
    Map<String, String> header = {
      "X_FB_PHOTO_WATERFALL_ID": adID,
      "X-Entity-Length": post.length.toString(),
      "X-Entity-Name": upload,
      "X-Instagram-Rupload-Params": jsonEncode(img2),
      "X-Entity-Type": "image/jpeg",
      "Offset": "0",
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "IG-INTENDED-USER-ID": account.dsUserID,
      "Content-Type": "application/octet-stream",
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse("https://i.instagram.com/" + endpoint);
    var request = http.Request(
      "POST",
      uri,
    )
      ..headers.addAll(header)
      ..bodyBytes = post;

    http.Response response =
        await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      print('Burda 1 ${response.statusCode} ${response.body}');
      print(jsonDecode(response.body)["upload_id"]);

      return jsonDecode(response.body)["upload_id"];
    } else {
      print('Burda 2 ${response.statusCode} ${response.body}');
      return null;
    }
  }

  static Future uploadMedia(
      endpoint, post, InstagramAccount account, imaj8) async {
    Map<String, String> header = {
      "X-IG-App-Locale": "tr_TR",
      "X-IG-Device-Locale": "tr_TR",
      "X-IG-Mapped-Locale": "tr_TR",
      "X-Pigeon-Session-Id": pigeonID,
      "X-Pigeon-Rawclienttime": "1609072393.620",
      "X-IG-Connection-Speed": 10000.toString() + "kbps",
      "X-IG-Bandwidth-Speed-KBPS": 9999999.toString(),
      "X-IG-Bandwidth-TotalBytes-B": 900000.toString(),
      "X-IG-Bandwidth-TotalTime-MS": 150.toString(),
      "X-IG-App-Startup-Country": "TR",
      "X-Bloks-Version-Id": bloksVersionID,
      "X-IG-WWW-Claim": account.claim,
      "X-Bloks-Is-Layout-RTL": "false",
      "X-Bloks-Is-Panorama-Enabled": "false",
      "X-IG-Device-ID": instaDeviceID,
      "X-IG-Android-ID": osID,
      "X-IG-Timezone-Offset": "10800",
      "X-IG-Nav-Chain":
          "4Ws:reel_composer_camera:17,5FC:quick_capture_fragment:18,5FC:quick_capture_fragment:19,TRUNCATEDx9,EYc:video_filter:29,E2p:video_scrubber:30,FollowersShareFragment:metadata_followers_share:31,1nj:feed_timeline:32,EXy:gallery_picker:33,EYb:photo_filter:34,FollowersShareFragment:metadata_followers_share:35",
      "retry_context": jsonEncode(imaj8),
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "Cookie":
          "ig_direct_region_hint=ATN; ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; shbts=1610900130.1874826; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; shbid=3810; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "Connection": "keep-alive",
    };

    var response = await http.post(Uri.parse(API_URL + endpoint),
        headers: header, body: post);
    print('Sonuc; ');
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      print('esle : ${jsonDecode(response.body)["message"]}');
      return jsonDecode(response.body)["message"];
    }
  }
}
