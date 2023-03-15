// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';

import 'package:togetherearn/a1/instagramAccounts/server/server.dart';
import 'package:togetherearn/a1/server/values.dart';
import 'package:http/http.dart' as http;

class LoginServer {
  static Future sendRequestForCookies() async {
    url =
        "https://b.i.instagram.com/api/v1/zr/token/result/?device_id=%22$osID%22&token_hash=&custom_device_id=%22$instaDeviceID%22&fetch_reason=token_expired";

    headerscc = {
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
      "X-IG-Timezone-Offset": "10800",
      "X-IG-Connection-Type": "MOBILE(LTE)",
      "X-IG-Capabilities": "3brTvx8=",
      "X-IG-App-ID": "567067343352427",
      "User-Agent": userAgent,
      "Accept-Language": "${cCode.replaceFirst('_', '-')}, en-US",
      "IG-INTENDED-USER-ID": "0",
      "Host": "b.i.instagram.com",
      "X-FB-HTTP-Engine": "Liger",
      "X-FB-Client-IP": "True",
      "X-FB-SERVER-CLUSTER": "True",
      "Connection": "keep-alive"
    };

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
    var mid = headers["ig-set-x-mid"];

    print("0.mid>>>: $mid, mid.runtimeType: ${mid.runtimeType}");
    return mid.toString();
  }

  static Future<Map<String, dynamic>> login(String userName, String password,
      String mobilCountryCode, String countryCode,
      {bool ghost = false}) async {
    String url = API_URL + "accounts/login/";
    String mid = await sendRequestForCookies();
    cCode = countryCode.toString();
    print(
        "Got tokens $mid, countryCode:  $mobilCountryCode, localeInfo: $countryCode");

    if (mid == null) {
      return null;
    }

    //   jazost = "22" + str(random.randint(100, 999))   #"22506"  "22158"
    //   print("jazost: ", jazost)
    Random random = Random();
    int randomNumber = random.nextInt(900) + 100;
    String jazoest = "22$randomNumber";
    timeson114 =
        (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

    var body = {
      "jazoest": jazoest,
      "country_codes":
          "[{\"country_code\":\"$mobilCountryCode\",\"source\":[\"default\",\"sim\"]}]",
      "phone_id": phoneID,
      "enc_password": "#PWD_INSTAGRAM:0:$timeson114:$password",
      "username": userName,
      "adid": adID,
      "guid": guID,
      "device_id": osID,
      "google_tokens": "[]",
      "login_attempt_count": "0"
    };

    String signature = Server.generateSignature(data: jsonEncode(body));

    Map<String, String> headerslg = {
      'X-IG-App-Locale': cCode,
      'X-IG-Device-Locale': cCode,
      'X-IG-Mapped-Locale': cCode,
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': timeson114,
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
      'X-IG-Connection-Type': 'MOBILE(LTE)',
      'X-IG-Capabilities': '3brTvx0=',
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': '${countryCode.replaceFirst('_', '-')}, en-US',
      'X-MID': mid.toString(),
      'IG-INTENDED-USER-ID': '0',
      'Content-Type': ' application/x-www-form-urlencoded; charset=UTF-8',
      'Accept-Encoding': 'gzip, deflate',
      'Host': 'i.instagram.com',
      'Connection': 'keep-alive',
    };

    print("0-headerslg: $headerslg . ${headerslg.runtimeType}");

    var response =
        await http.post(Uri.parse(url), headers: headerslg, body: signature);

    print('0-Ahanda : ${response.statusCode}, \n**Signature: $signature');

    if (response.statusCode == 200) {
      Map<String, String> result = {
        "mid": mid.toString(),
        "rur": response.headers["ig-set-ig-u-rur"],
        "authorization": response.headers["ig-set-authorization"], //kaydolcak
        "dsUserID": response.headers["ig-set-ig-u-ds-user-id"], //kaydolcak
        "claim": response.headers["x-ig-set-www-claim"], //kaydolcak
        "mobilCountryCode": mobilCountryCode.toString()
      };
      print("1-result: $result");

      return getNewToken(result).then((result) async {
        print("2-getNewToken: $result");
        return accountFamily(result).then((result) async {
          print("3-accountFamily: $result");
          return getInbox(result).then((result) async {
            print("4-getInbox: $result");
            Map<String, dynamic> loginResult = {
              "user_name": userName,
              "password": password,
              "pwd_password": "#PWD_INSTAGRAM:0:$timeson114:$password",
              "claim": result["claim"],
              "auth_token": result["authorization"],
              "rur": result["rur"],
              "ds_user_id": dsUserID,
              "mid": result["mid"],
              "ghost": ghost,
              "shbid": result["shbid"],
              "shbts": result["shbts"],
              "region_hint": result["regionHint"],
            };
            print('5-Son-loginResult: $loginResult');
            return loginResult;
          });
        });
      });

    } else {
      print('Login failed: ${response.statusCode}');
      return null;
    }
  }



// 1-yenitoken1()
  static Future getNewToken(Map result) async {
    headerscc['X-IG-App-Locale'] = cCode;
    headerscc['X-IG-Device-Locale'] = cCode;
    headerscc['X-IG-Mapped-Locale'] = cCode;
    headerscc['X-Pigeon-Session-Id'] = pigeonID;
    headerscc['Authorization'] = result["authorization"];
    headerscc['X-MID'] = result["mid"];
    headerscc['IG-U-DS-USER-ID'] = dsUserID;
    headerscc['IG-INTENDED-USER-ID'] = dsUserID;
    headerscc['X-IG-Family-Device-ID'] = appDeviceID;

    var response = await http.get(Uri.parse(url), headers: headerscc);
    result['status'] = response.statusCode.toString();
    result["mid"] = response.headers["ig-set-x-mid"];
    result["rur"] = response.headers["ig-set-ig-u-rur"];
    return result;
  }

  // 2-account_family()
  static Future accountFamily(result) async {
    Map<String, String> headers = {
      'X-IG-App-Locale': cCode,
      'X-IG-Device-Locale': cCode,
      'X-IG-Mapped-Locale': cCode,
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': timeson114,
      'X-IG-Bandwidth-Speed-KBPS': '-1.000',
      'X-IG-Bandwidth-TotalBytes-B': '0',
      'X-IG-Bandwidth-TotalTime-MS': '0',
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': '0',
      'X-Bloks-Is-Layout-RTL': 'false',
      'X-Bloks-Is-Panorama-Enabled': 'true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      'X-IG-Timezone-Offset': '10800',
      'X-IG-Connection-Type': 'MOBILE(LTE)',
      'X-IG-Capabilities': '3brTv10=',
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': 'tr-TR, en-US',
      'Authorization': result["authorization"],
      'X-MID': result["mid"].toString(),
      'IG-U-DS-USER-ID': dsUserID,
      'IG-INTENDED-USER-ID': dsUserID,
      'Accept-Encoding': 'gzip, deflate',
      'Host': 'b.i.instagram.com',
      'X-FB-HTTP-Engine': 'Liger',
      'X-FB-Client-IP': 'True',
      'X-FB-Server-Cluster': 'True',
      'Connection': 'keep-alive'
    };
    var uri =
        "https://b.i.instagram.com/api/v1/multiple_accounts/get_account_family/";
    var response = await http.get(Uri.parse(url), headers: headers);
    result['status'] = response.statusCode.toString();
    result["shbid"] = response.headers['ig-set-ig-u-shbid']; //kaydolcak
    result["shbts"] = response.headers['ig-set-ig-u-shbts']; //kaydolcak
    result["rur"] = response.headers["ig-set-ig-u-rur"];
    return result;
  }

// 3-inbox1()
  static Future getInbox(result) async {
    Map<String, String> headers = {
      'X-IG-App-Locale': cCode,
      'X-IG-Device-Locale': cCode,
      'X-IG-Mapped-Locale': cCode,
      'X-Pigeon-Session-Id': pigeonID,
      'X-Pigeon-Rawclienttime': timeson114,
      'X-IG-Bandwidth-Speed-KBPS': '-1.000',
      'X-IG-Bandwidth-TotalBytes-B': '0',
      'X-IG-Bandwidth-TotalTime-MS': '0',
      'X-IG-App-Startup-Country': result["mobilCountryCode"].toString(),
      'X-Bloks-Version-Id': bloksVersionID,
      'X-IG-WWW-Claim': result["claim"],
      'X-Bloks-Is-Layout-RTL': 'false',
      'X-Bloks-Is-Panorama-Enabled': 'true',
      'X-IG-Device-ID': instaDeviceID,
      'X-IG-Family-Device-ID': appDeviceID,
      'X-IG-Android-ID': osID,
      'X-IG-Timezone-Offset': '10800',
      'X-IG-Connection-Type': 'MOBILE(LTE)',
      'X-IG-Capabilities': '3brTv10=',
      'X-IG-App-ID': '567067343352427',
      'User-Agent': userAgent,
      'Accept-Language': '$cCode, en-US',
      'Authorization': result["authorization"],
      'X-MID': result["mid"],
      'IG-U-SHBID': result["shbid"],
      'IG-U-SHBTS': result["shbts"],
      'IG-U-DS-USER-ID': dsUserID,
      'IG-U-RUR': result["rur"],
      'IG-INTENDED-USER-ID': dsUserID,
      'Accept-Encoding': 'gzip, deflate',
      'Host': 'z-p42.i.instagram.com',
      'X-FB-HTTP-Engine': 'Liger',
      'X-FB-Client-IP': 'True',
      'X-FB-Server-Cluster': 'True',
      'Connection': 'keep-alive',
    };

    url =
        'https://z-p42.i.instagram.com/api/v1/direct_v2/inbox/?visual_message_return_type=unseen&persistentBadging=true&limit=0';
    print('headers:headers.runtimeType: ${headers.runtimeType}');
    var response = await http.get(Uri.parse(url), headers: headers);
    result['status'] = response.statusCode.toString();
    result['rur'] = response.headers['ig-set-ig-u-rur']; //kaydolcak
    result['regionHint'] =
        response.headers['ig-set-ig-u-ig-direct-region-hint']; //kaydolcak
    result['claim'] = response.headers['ig-set-ig-u-www-claim']; //kaydolcak

    return result;
  }
}
