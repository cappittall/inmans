import 'dart:convert';

import 'package:togetherearn/a1/instagramAccounts/server/server.dart';
import 'package:togetherearn/a1/server/values.dart';
import 'package:http/http.dart' as http;

class LoginServer {
  static Future sendRequestForCookies() async {
    String url =
        "https://b.i.instagram.com/api/v1/zr/token/result/?device_id=%22$osID%22&token_hash=&custom_device_id=%22$instaDeviceID%22&fetch_reason=token_expired";

    var headerscc = {
      "X-IG-Connection-Speed": "-1kbps",
      "X-IG-Bandwidth-Speed-KBPS": "-1.000",
      "X-IG-Bandwidth-TotalBytes-B": "0",
      "X-IG-Bandwidth-TotalTime-MS": "0",
      "X-Bloks-Version-Id": bloksVersionID,
      "X-IG-WWW-Claim": "0",
      "X-Bloks-Is-Layout-RTL": "false",
      "X-Bloks-Is-Panorama-Enabled": "false",
      "X-IG-Device-ID": instaDeviceID,
      "X-IG-Android-ID": osID,
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "IG-INTENDED-USER-ID": "0",
      "Host": "b.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "X-FB-SERVER-CLUSTER": "True",
      "Connection": "keep-alive"
    };

    // var headers = {
    //   'X-IG-App-Locale': 'tr_TR',
    //   'X-IG-Device-Locale': 'tr_TR',
    //   'X-IG-Mapped-Locale': 'tr_TR',
    //   'X-Pigeon-Session-Id': pigeonID,
    //   'X-Pigeon-Rawclienttime': '1626520650.834',
    //   'X-IG-Bandwidth-Speed-KBPS': '-1.000',
    //   'X-IG-Bandwidth-TotalBytes-B': '0',
    //   'X-IG-Bandwidth-TotalTime-MS': '0',
    //   'X-Bloks-Version-Id':
    //       bloksVersionID,
    //   'X-IG-WWW-Claim': '0',
    //   'X-Bloks-Is-Layout-RTL': ' false',
    //   'X-Bloks-Is-Panorama-Enabled': ' true',
    //   'X-IG-Device-ID': instaDeviceID,
    //   'X-IG-Family-Device-ID': appDeviceID,
    //   'X-IG-Android-ID': osID,
    //   'X-IG-Timezone-Offset': '10800',
    //   'X-IG-Connection-Type': 'WIFI',
    //   'X-IG-Capabilities': '3brTvx0=',
    //   'X-IG-App-ID': '567067343352427',
    //   'User-Agent': userAgent,
    //   'Accept-Language': 'tr-TR, en-US',
    //   'X-MID': 'YPK8CgABAAHKtBHODRDmq2xKbcNd',
    //   'IG-INTENDED-USER-ID': '0',
    //   'Content-Type': ' application/x-www-form-urlencoded; charset=UTF-8',
    //   'Accept-Encoding': 'zstd, gzip, deflate',
    //   'Host': 'i.instagram.com',
    //   'Connection': 'keep-alive',

    // };

    var response = await http.get(
      Uri.parse(url),
      headers: headerscc,
    );
    print("Response ${response.statusCode}");
    print("Response ${response.body}");
    print("Response ${response.headers}");

    if (response.statusCode != 200) {
      return null;
    }

    var headers = response.headers;

    // mid: ig-set-x-mid

    String mid = headers["ig-set-x-mid"];

    // headers.forEach((key, value) {
    //   print("===");
    //   print(key);
    //   print(value);

    return [mid];
  }

  static Future<String> pwdPassword(String password) async {
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> body = {
      "id": instaDeviceID,
      "server_config_retrieval": "1",
      "experiments":
          "ig_android_reg_nux_headers_cleanup_universe,ig_android_device_detection_info_upload,ig_android_nux_add_email_device,ig_android_gmail_oauth_in_reg,ig_android_device_info_foreground_reporting,ig_android_device_verification_fb_signup,ig_android_direct_main_tab_universe_v2,ig_android_passwordless_account_password_creation_universe,ig_android_direct_add_direct_to_android_native_photo_share_sheet,ig_growth_android_profile_pic_prefill_with_fb_pic_2,ig_account_identity_logged_out_signals_global_holdout_universe,ig_android_quickcapture_keep_screen_on,ig_android_device_based_country_verification,ig_android_login_identifier_fuzzy_match,ig_android_reg_modularization_universe,ig_android_security_intent_switchoff,ig_android_device_verification_separate_endpoint,ig_android_suma_landing_page,ig_android_sim_info_upload,ig_android_smartlock_hints_universe,ig_android_fb_account_linking_sampling_freq_universe,ig_android_retry_create_account_universe,ig_android_caption_typeahead_fix_on_o_universe"
    };

    List pwdData = await sendRequest2pwd(
        'qe/sync/', Server.generateSignature(data: jsonEncode(body)));

    //var data9a = pwdData[0];
    var data10 = pwdData[1];
    var publicKeyID = data10["ig-set-password-encryption-key-id"];
    var publicKey = data10["ig-set-password-encryption-pub-key"];
    Map<String, dynamic> postData = {
      "keyid": publicKeyID,
      "pubkey": publicKey,
      "time": timeStamp,
      "password": password
    };

    var response = await http.post(
        Uri.parse("https://argeelektrik.com/insta/mobilpwd.php"),
        body: postData);

    return response.body;
  }

  static Future<List> sendRequest2pwd(endpoint, post) async {
    var headersbg = {
      "X-IG-App-Locale": "tr_TR",
      "X-IG-Device-Locale": "tr_TR",
      "X-IG-Mapped-Locale": "tr_TR",
      "X-Pigeon-Session-Id": pigeonID,
      "X-Pigeon-Rawclienttime": "1608885245.740",
      "X-IG-Connection-Speed": "-1kbps",
      "X-IG-Bandwidth-Speed-KBPS": "-1.000",
      "X-IG-Bandwidth-TotalBytes-B": "0",
      "X-IG-Bandwidth-TotalTime-MS": "0",
      "X-Bloks-Version-Id": bloksVersionID,
      "X-IG-WWW-Claim": "0",
      "X-Bloks-Is-Layout-RTL": "false",
      "X-Bloks-Is-Panorama-Enabled": "false",
      "X-IG-Device-ID": appDeviceID,
      "X-IG-Android-ID": osID,
      "X-IG-Connection-Type": "WIFI",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "tr-TR, en-US",
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "Accept-Encoding": "gzip, deflate",
      "Host": "b.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "Connection": "keep-alive"
    };

    http.Response response = await http.post(Uri.parse(API_URL + endpoint),
        body: post, headers: headersbg);

    return [jsonDecode(response.body.toString()), response.headers];
  }

  static Future<Map<String, dynamic>> login(
      {String username, String password, bool ghost = false}) async {
    String url = API_URL + "accounts/login/";

    /*  
    gerek kalmamış
    String pasl = await pwdPassword(password);

    print("Got PASL");

     if (pasl.trim() == "") {
      return null;
    } 
    */

    List tokens = await sendRequestForCookies();

    print("Got tokens $tokens");

    if (tokens == null) {
      return null;
    }

    //String csrftoken = tokens[0];
    String mid = tokens[0];

    // Burayı flutter e convert et
    // python - str(int(datetime.now().timestamp()))
    var timeson114 =
        (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

    var body = {
      "jazoest": "22553",
      "country_codes":
          "[{\"country_code\":\"90\",\"source\":[\"default\",\"sim\"]}]",
      "phone_id": phoneID,
      "enc_password": "#PWD_INSTAGRAM:0:$timeson114:$password",
      "username": username,
      "adid": adID,
      "guid": guID,
      "device_id": osID,
      "google_tokens": "[]",
      "login_attempt_count": "0"
    };

    String signature = Server.generateSignature(data: jsonEncode(body));

    var headerslg = {
      'X-IG-App-Locale': 'tr_TR',
      'X-IG-Device-Locale': 'tr_TR',
      'X-IG-Mapped-Locale': 'tr_TR',
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': '1626520650.834',
      'X-IG-Bandwidth-Speed-KBPS': '-1.000',
      'X-IG-Bandwidth-TotalBytes-B': '0',
      'X-IG-Bandwidth-TotalTime-MS': '0',
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': '0',
      'X-Bloks-Is-Layout-RTL': ' false',
      'X-Bloks-Is-Panorama-Enabled': ' true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      'X-IG-Timezone-Offset': '10800',
      'X-IG-Connection-Type': 'WIFI',
      'X-IG-Capabilities': '3brTvx0=',
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': 'tr-TR, en-US',
      'X-MID': mid,
      'IG-INTENDED-USER-ID': '0',
      'Content-Type': ' application/x-www-form-urlencoded; charset=UTF-8',
      'Accept-Encoding': 'zstd, gzip, deflate',
      'Host': 'i.instagram.com',
      'Connection': 'keep-alive',
    };

    var response =
        await http.post(Uri.parse(url), headers: headerslg, body: signature);

    print(
        'Ahanda buraya bak: ${response.statusCode}, \n*********************\n\nHeaderslg: $headerslg \nSignature: $signature');

    if (response.statusCode == 200) {
      var loginHeaders = response.headers;
      print(loginHeaders);

      print("Headers: ");
      print(response.headers);
      print("Body:");

      print("Login Headers:");

      String rur = loginHeaders["ig-set-ig-u-rur"];
      String authorization = loginHeaders["ig-set-authorization"];
      String dsUserID = loginHeaders["ig-set-ig-u-ds-user-id"];
      String claim = loginHeaders["x-ig-set-www-claim"];

      // var claim = loginHeaders["x-ig-set-www-claim"];
      // var authorization = loginHeaders["ig-set-authorization"];
      // var cookie = loginHeaders["set-cookie"];

      // List<String> cookieList = cookie.split(";");
      // var _csrftoken = cookieList[0].replaceAll("csrftoken=", "").trim();
      // var rur = cookieList[5].replaceAll("Secure,rur=", "").trim();
      // var dsUserId = cookieList[9].replaceAll("Secure,ds_user_id=", "").trim();
      // var sessionId = cookieList[14].replaceAll("Secure,sessionid=", "").trim();

      Map<String, dynamic> loginResult = {
        "userName": username,
        "password": password,
        "enc_password": "#PWD_INSTAGRAM:0:$timeson114:$password",
        "claim": claim,
        "authToken": authorization,
        "rur": rur,
        "dsUserID": dsUserID,
        "mid": mid,
        "ghost": ghost,
      };
      return loginResult;
    } else {
      return null;
    }
  }
}
