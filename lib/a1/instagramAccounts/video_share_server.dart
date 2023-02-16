import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../server/values.dart';
import 'server/server.dart';

/// Uygulama aktif / değil
/// takip beğeni yorum için firebase yapısı
/// bakiye
/// sunucudan hesap ekleme
/// user agent vb veriler sunucuya
///

class VideoShareServer {
  static Future shareVideo({
    InstagramAccount account,
    Uint8List idToInteract,
    String text,
  }) async {
    print("Sharing video");
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    String upload = Server.uuid.v4();

    String postURL = "rupload_igvideo/$upload?segmented=true&phase=start";

    String postCaption = text;

    Directory appDocDir = await getApplicationDocumentsDirectory();

    bool dirExists =
        await Directory(appDocDir.path + "/shares/videos").exists();
    print(
        'Dir exists ? $dirExists \nSav dir:${appDocDir.path + "/shares/videos/$timeStamp-video.mp4"}');

    if (!dirExists) {
      await Directory(appDocDir.path + "/shares/videos")
          .create(recursive: true);
    }

    File video = File(appDocDir.path + "/shares/videos/$timeStamp-video.mp4");

    await video.writeAsBytes(idToInteract);

    VideoPlayerController controller = VideoPlayerController.file(video);

    await controller.initialize();
    await controller.play();

    int durationSec = controller.value.duration.inSeconds;
    int durationMilisec = controller.value.duration.inMilliseconds;
    int msFp = durationMilisec - durationSec * 1000;

    double duration = durationSec + (msFp / 1000);

    print(
        "controller done duration  $durationMilisec - $durationSec *1000 =  $msFp ");

    controller.dispose();

    var uploadParams = {
      "upload_media_height": "600",
      "xsharing_user_ids": "[]",
      "upload_media_width": "600",
      "upload_media_duration_ms": durationMilisec.toString(),
      "content_tags": "use_default_cover",
      "upload_id": timeStamp.toString(),
      "retry_context":
          "{\"num_reupload\":0,\"num_step_auto_retry\":0,\"num_step_manual_retry\":0}",
      "media_type": "2"
    };

    var videoBytes = video.readAsBytesSync();

    print("Got video bytes $videoBytes");

    String streamID =
        await getStreamID(postURL, videoBytes, account, upload, uploadParams);

    print("Got stream id $streamID");

    if (streamID == null) {
      return 404;
    }

    String transferID = Server.uuid.v4().replaceAll("-", "");

    String videoLength = videoBytes.length.toString();

    var getTransfer1Header = {
      "Stream-Id": streamID,
      "X-Instagram-Rupload-Params": jsonEncode(uploadParams),
      "Segment-Start-Offset": "0",
      "X_FB_VIDEO_WATERFALL_ID": adID,
      "Segment-Type": "2",
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Accept-Encoding": "gzip, deflate",
      "Host": "z-p42.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "X-FB-Server-Cluster": "True",
      "Connection": "keep-alive",
    };

    String entityName =
        "$transferID-0-$videoLength-1619886944000-1619886944000";

    var postTransfer1Header = {
      "Stream-Id": streamID,
      "X-Instagram-Rupload-Params": jsonEncode(uploadParams),
      "Segment-Start-Offset": "0",
      "X_FB_VIDEO_WATERFALL_ID": adID,
      "Segment-Type": "2",
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "Cookie":
          "ig_direct_region_hint=ATN; ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; shbid=3810; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Accept-Encoding": "gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "X-Entity-Length": videoLength,
      "X-Entity-Name": entityName,
      "X-Entity-Type": "video/mp4",
      "Offset": "0",
      "Content-Type": "application/octet-stream",
      "Content-Length": videoLength,
    };

    await http.get(
        Uri.parse(
            "https://i.instagram.com/rupload_igvideo/$entityName?segmented=true&phase=transfer"),
        headers: getTransfer1Header);

    var uri = Uri.parse(
        "https://i.instagram.com/rupload_igvideo/$entityName?segmented=true&phase=transfer");
    var request = http.Request(
      "POST",
      uri,
    )
      ..headers.addAll(postTransfer1Header)
      ..bodyBytes = videoBytes;

    await http.Response.fromStream(await request.send());

    print("Posted video");

    var endHeader = {
      "Stream-Id": streamID,
      "X-Instagram-Rupload-Params": jsonEncode(uploadParams),
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "Cookie":
          "ig_direct_region_hint=ATN; ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; shbid=3810; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Accept-Encoding": "gzip, deflate",
      "Host": "z-p42.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "Content-length": "0"
    };

    var postEnd = await http.post(
        Uri.parse(
            "https://i.instagram.com/rupload_igvideo/${Server.uuid.v4()}?segmented=true&phase=end"),
        headers: endHeader);

    print("Got photo response ${postEnd.statusCode}");

    print(postEnd.body);

    if (postEnd.statusCode != 200) {
      return postEnd.statusCode;
    }

    var thumbnail = await VideoThumbnail.thumbnailData(
      video: video.path,
      imageFormat: ImageFormat.JPEG,
      quality: 50,
    );

/*    File _image = await getImage();

    var post = _image.readAsBytesSync();*/

    int randomNumber = Server.randomNumber(1000000000, 4294967296);

    Map<String, String> photoHeader = {
      "X_FB_PHOTO_WATERFALL_ID": adID,
      "X-Entity-Length": thumbnail.length.toString(),
      "X-Entity-Name": "${timeStamp}_0_$randomNumber",
      "X-Instagram-Rupload-Params": jsonEncode({
        "upload_id": timeStamp.toString(),
        "media_type": "2",
        "retry_context":
            "{\"num_reupload\":0,\"num_step_auto_retry\":0,\"num_step_manual_retry\":0}",
        "image_compression":
            "{\"lib_name\":\"moz\",\"lib_version\":\"3.1.m\",\"quality\":\"0\"}",
        "xsharing_user_ids": "[]"
      }),
      "X-Entity-Type": "image/jpeg",
      "Offset": "0",
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "FRC",
      "Authorization": account.authToken,
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "DEBUG-IG-USER-ID": account.dsUserID,
      "Content-Type": "application/octet-stream",
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-Client-IP": "True",
      "X-FB-HTTP-Engine": "Liger",
      "Connection": "keep-alive",
      "Content-Length": thumbnail.length.toString()
    };

    print("sending photo response");

    var photoURI = Uri.parse(
        "https://i.instagram.com/rupload_igphoto/${timeStamp}_0_$randomNumber");
    var photoRequest = http.Request(
      "POST",
      photoURI,
    )
      ..headers.addAll(photoHeader)
      ..bodyBytes = thumbnail;

    http.Response photoResponse =
        await http.Response.fromStream(await photoRequest.send());

    print("Got photo response");

    print(photoResponse.body);

    if (photoResponse.statusCode != 200) {
      return photoResponse.statusCode;
    }

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

    var finishBody = {
      "filter_type": "0",
      "timezone_offset": "10800",
      "_csrftoken": account.csrftoken,
      "source_type": "4",
      "video_result": "",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": guID,
      "caption": postCaption,
      "date_time_original": timeStamp.toString(),
      "upload_id": timeStamp.toString(),
      "device": {
        "manufacturer": manufacturer,
        "model": model,
        "android_version": version,
        "android_release": release
      },
      "length": duration,
      "clips": [
        {"length": duration, "source_type": "4"}
      ],
      "extra": {"source_width": 600, "source_height": 600},
      "audio_muted": false,
      "poster_frame_index": 0
    };

    print("finishing upload");

    var resultOfFinish = await finishUpload("postUploadURL",
        Server.generateSignature(data: jsonEncode(finishBody)), account);

    print("result of finishing $resultOfFinish");

    int tries = 3;

    while (tries > 0 && resultOfFinish == null) {
      resultOfFinish = await finishUpload("postUploadURL",
          Server.generateSignature(data: jsonEncode(finishBody)), account);
      tries--;
    }

    if (resultOfFinish != 200) {
      return resultOfFinish;
    }

    var body = {
      "filter_type": "0",
      "timezone_offset": "10800",
      "_csrftoken": account.csrftoken,
      "source_type": "4",
      "video_result": "",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": guID,
      "creation_logger_session_id": account.sessionID,
      "caption": postCaption,
      "date_time_original": "19040101T000000.000Z",
      "upload_id": timeStamp.toString(),
      "multi_sharing": "1",
      "device": {
        "manufacturer": manufacturer,
        "model": model,
        "android_version": version,
        "android_release": release
      },
      "length": duration,
      "clips": [
        {"length": duration, "source_type": "4"}
      ],
      "extra": {"source_width": 600, "source_height": 600},
      "audio_muted": false,
      "poster_frame_index": 0
    };

    String postUploadURL = "media/configure/";

    print(body);

    return await uploadMedia(postUploadURL,
        Server.generateSignature(data: jsonEncode(body)), account);
  }

  static Future<String> getStreamID(endpoint, video, InstagramAccount account,
      String upload, uploadParams) async {
    Map<String, String> header = {
      "X-Instagram-Rupload-Params": jsonEncode(uploadParams),
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "IG-INTENDED-USER-ID": account.dsUserID,
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "X-FB-Server-Cluster": "True",
      "Connection": "keep-alive",
      "Content-Length": "0"
    };

    var uri = Uri.parse("https://i.instagram.com/$endpoint");
    var request = http.Request(
      "POST",
      uri,
    )..headers.addAll(header);

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(' Satır. 409: getStreamID ${jsonDecode(response.body).toString()}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["stream_id"].toString();
    } else {
      return null;
    }
  }

  static Future finishUpload(
    endpoint,
    post,
    InstagramAccount account,
  ) async {
    Map<String, String> header = {
      "X-IG-App-Locale": cCode,
      "X-IG-Device-Locale": cCode,
      "X-IG-Mapped-Locale": cCode,
      "X-Pigeon-Session-Id": pigeonID,
      "X-Pigeon-Rawclienttime": "1609072393.620",
      "X-IG-Connection-Speed": 10000.toString() + "kbps",
      "X-IG-Bandwidth-Speed-KBPS": 9999999.toString(),
      "X-IG-Bandwidth-TotalBytes-B": 900000.toString(),
      "X-IG-Bandwidth-TotalTime-MS": 150.toString(),
      "X-IG-App-Startup-Country": cCode.split('_')[1],
      "X-Bloks-Version-Id": bloksVersionID,
      "X-IG-WWW-Claim": account.claim,
      "X-Bloks-Is-Layout-RTL": "false",
      "X-Bloks-Is-Panorama-Enabled": "false",
      "X-IG-Device-ID": instaDeviceID,
      "X-IG-Android-ID": osID,
      "retry_context": jsonEncode({
        "num_reupload": 0,
        "num_step_auto_retry": 0,
        "num_step_manual_retry": 0
      }),
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Priority": "u=3",
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "Cookie":
          "ig_direct_region_hint=ATN; ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; shbid=3810; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-SHBID": "3810",
      "IG-U-SHBTS": "1609266568.7728953",
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "Content-Length": post.length.toString(),
    };

    var response = await http.post(
        Uri.parse(
            "https://i.instagram.com/api/v1/media/upload_finish/?video=1"),
        headers: header,
        body: post);

    print(' Satır. 479: finishUpload ${response.body}');
    return response.statusCode;
  }

  static Future uploadMedia(
    endpoint,
    post,
    InstagramAccount account,
  ) async {
    print("upload started");

    Map<String, String> header = {
      "X-IG-App-Locale": cCode,
      "X-IG-Device-Locale": cCode,
      "X-IG-Mapped-Locale": cCode,
      "X-Pigeon-Session-Id": pigeonID,
      "X-Pigeon-Rawclienttime": "1609072393.620",
      "X-IG-Connection-Speed": 10000.toString() + "kbps",
      "X-IG-Bandwidth-Speed-KBPS": 9999999.toString(),
      "X-IG-Bandwidth-TotalBytes-B": 900000.toString(),
      "X-IG-Bandwidth-TotalTime-MS": 150.toString(),
      "X-IG-App-Startup-Country": cCode.split('_')[1],
      "X-Bloks-Version-Id": bloksVersionID,
      "X-IG-WWW-Claim": account.claim,
      "X-Bloks-Is-Layout-RTL": "false",
      "X-Bloks-Is-Panorama-Enabled": "false",
      "X-IG-Device-ID": instaDeviceID,
      "X-IG-Android-ID": osID,
      "retry_context": jsonEncode({
        "num_reupload": 0,
        "num_step_auto_retry": 0,
        "num_step_manual_retry": 0
      }),
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "Priority": "u=3",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "Cookie":
          "ig_direct_region_hint=ATN; ds_user=${account.userName}; ds_user_id=${account.dsUserID}; mid=${account.mid}; sessionid=${account.sessionID}; csrftoken=${account.csrftoken}; shbid=3810; rur=${account.rur}",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-SHBID": "3810",
      "IG-U-SHBTS": "1609266568.7728953",
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "Content-Length": post.length.toString(),
    };

    print("sending response");

    print(API_URL + endpoint);

    http.Response response = await http.post(Uri.parse(API_URL + endpoint),
        headers: header, body: post.toString());

    // print(' Satır. 537: uploadMedia ${json.encode(response.body)}');

    return response.statusCode;
  }
}
