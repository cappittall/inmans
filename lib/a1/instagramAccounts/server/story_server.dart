import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../server/values.dart';
import 'server.dart';

class StoryServer {
  static Future<String> uploadStoryVideo(
      {InstagramAccount account, Uint8List idToInteract, String text}) async {
    print("Sharing story");
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    String uploadUuid = Server.uuid.v4();

    Directory appDocDir = await getApplicationDocumentsDirectory();

    bool dirExists =
        await Directory(appDocDir.path + "/shares/stories").exists();

    if (!dirExists) {
      await Directory(appDocDir.path + "/shares/stories")
          .create(recursive: true);
    }

    File video = File(appDocDir.path + "/shares/stories/$timeStamp-story.mp4");

    await video.writeAsBytes(idToInteract);

    VideoPlayerController controller = VideoPlayerController.file(video);
    await controller.initialize();

    int durationSec = controller.value.duration.inSeconds;
    int durationMilisec = controller.value.duration.inMilliseconds;
    int msFp = durationMilisec - durationSec * 1000;

    double duration = durationSec + (msFp / 1000);

    var videoBytes = video.readAsBytesSync();

    print("controller initialized");

    String videoLength = videoBytes.length.toString();

    String entityName =
        "$uploadUuid-0-$videoLength-1619886686000-1619886686000";

    controller.dispose();

    var uploadParams = {
      "upload_media_height": "1196",
      "extract_cover_frame": "1",
      "xsharing_user_ids": "[]",
      "upload_media_width": "720",
      "for_direct_story": "1",
      "upload_media_duration_ms": durationMilisec.toString(),
      "content_tags": "use_default_cover,has-overlay",
      "upload_id": timeStamp.toString(),
      "for_album": "1",
      "retry_context":
          "{\"num_reupload\":0,\"num_step_auto_retry\":0,\"num_step_manual_retry\":0}",
      "media_type": "2"
    };

    var postHeader = {
      "X-Instagram-Rupload-Params": jsonEncode(uploadParams),
      "Segment-Start-Offset": "0",
      "X_FB_VIDEO_WATERFALL_ID": adID,
      "Segment-Type": "3",
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Priority": "u=3",
      "Accept-Language": "tr-TR, en-US",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Accept-Encoding": "gzip, deflate",
      "Host": "z-p42.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "IG-INTENDED-USER-ID": account.dsUserID,
      "Connection": "keep-alive",
      "X-Entity-Length": videoLength,
      "X-Entity-Name": entityName,
      "X-Entity-Type": "video/mp4",
      "Offset": "0",
      "Content-Type": "application/octet-stream",
      "Content-Length": videoLength,
    };

    var uploadURI =
        Uri.parse("https://i.instagram.com/rupload_igvideo/$entityName");
    var uploadRequest = http.Request(
      "POST",
      uploadURI,
    )
      ..headers.addAll(postHeader)
      ..bodyBytes = videoBytes;

    http.Response uploadResponse =
        await http.Response.fromStream(await uploadRequest.send());

    if (uploadResponse.statusCode != 200) {
      return null;
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

    var postBody = {
      "text_metadata":
          "[{\"font_size\":24.0,\"scale\":1.0,\"width\":486.0,\"height\":102.0,\"x\":0.49526718,\"y\":0.8048751,\"rotation\":0.0,\"format_type\":\"classic_v2\",\"effects\":[\"disabled\"],\"colors\":[\"#ffffff\"],\"alignment\":\"center\",\"animation\":\"\"}]",
      "supported_capabilities_new":
          "[{\"name\":\"SUPPORTED_SDK_VERSIONS\",\"value\":\"73.0,74.0,75.0,76.0,77.0,78.0,79.0,80.0,81.0,82.0,83.0,84.0,85.0,86.0,87.0,88.0,89.0,90.0,91.0,92.0,93.0,94.0,95.0,96.0,97.0,98.0,99.0,100.0,101.0,102.0,103.0,104.0,105.0,106.0\"},{\"name\":\"FACE_TRACKER_VERSION\",\"value\":\"14\"},{\"name\":\"COMPRESSION\",\"value\":\"ETC2_COMPRESSION\"},{\"name\":\"world_tracker\",\"value\":\"world_tracker_enabled\"},{\"name\":\"gyroscope\",\"value\":\"gyroscope_enabled\"}]",
      "allow_multi_configures": "1",
      "original_media_type": "video",
      "filter_type": "0",
      "camera_session_id": adID,
      "timezone_offset": "10800",
      "client_shared_at": timeStamp.toString(),
      "media_folder": "WhatsApp+Business+Video",
      "configure_mode": "1",
      "source_type": "4",
      "video_result": "",
      "_uid": account.dsUserID,
      "device_id": osID,
      "_uuid": guID,
      "creation_surface": "camera",
      "imported_taken_at": timeStamp.toString(),
      "caption": "deneme123",
      "date_time_original": timeStamp.toString(),
      "capture_type": "normal",
      "rich_text_format_types": "[\"classic_v2\"]",
      "upload_id": timeStamp.toString(),
      "client_timestamp": timeStamp.toString(),
      "device": {
        "manufacturer": manufacturer,
        "model": model,
        "android_version": version,
        "android_release": release
      },
      "length": duration,
      "implicit_location": {
        "media_location": {"lat": 0, "lng": 0}
      },
      "clips": [
        {"length": duration, "source_type": "4"}
      ],
      "extra": {"source_width": 720, "source_height": 1280},
      "audio_muted": false,
      "poster_frame_index": 0
    };

    return await uploadMedia("media/configure_to_story/?video=1",
        Server.generateSignature(data: jsonEncode(postBody)), account);
  }

  static Future uploadMedia(
    endpoint,
    post,
    InstagramAccount account,
  ) async {
    print("uploading story");
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
      "retry_context": jsonEncode({
        "num_reupload": 0,
        "num_step_auto_retry": 0,
        "num_step_manual_retry": 0
      }),
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "Priority": "u=3",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "Authorization": account.authToken,
      "X-MID": account.mid,
      "IG-U-SHBID": "3810",
      "IG-U-SHBTS": "1609266568.7728953",
      "IG-U-IG-DIRECT-REGION-HINT": "ATN",
      "IG-U-DS-USER-ID": account.dsUserID,
      "IG-INTENDED-USER-ID": account.dsUserID,
      "IG-U-RUR": account.rur,
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "zstd, gzip, deflate",
      "Host": "i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive",
      "Content-Length": post.length.toString(),
    };

    http.Response response = await http.post(Uri.parse(API_URL + endpoint),
        headers: header, body: post);

    if (response.statusCode == 200) {
      return "success";
    } else {
      return jsonDecode(response.body)["message"] ?? "fail";
    }
  }
}
