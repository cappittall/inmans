import 'package:encrypt/encrypt.dart';

class InstagramAccount {
  int id;
  String user_id;
  String userName;
  String password;
  String claim;
  String authToken;
  String csrftoken;
  String rur;
  String dsUserID;
  String sessionID;
  String pwdPassword;
  String mid;
  bool ghost;
  List locationTags;
  String gender;
  int followerCount;
  String country;
  String adminArea;
  String locality;
  String subLocality;

  InstagramAccount({
    this.id,
    this.user_id,
    this.userName,
    this.password,
    this.sessionID,
    this.pwdPassword,
    this.dsUserID,
    this.rur,
    this.claim,
    this.csrftoken,
    this.authToken,
    this.mid,
    this.ghost = false,
    this.locationTags,
    this.gender,
    this.followerCount,
  });

  factory InstagramAccount.fromData(Map<String, dynamic> data) {
    final key = Key.fromLength(32);

    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(data["password"], iv: iv);

    return InstagramAccount(
        id: data['id'], // database den gelen id
        user_id: data["user_id"],
        userName: data["userName"],
        password: encrypted.base64,
        pwdPassword: data["pwdPassword"],
        claim: data["claim"],
        authToken: data["authToken"],
        csrftoken: data["csrftoken"],
        rur: data["rur"],
        dsUserID: data["dsUserID"],
        sessionID: data["sessionID"],
        mid: data["mid"],
        ghost: data["ghost"],
        gender: data["gender"] ?? 'gd yok');
  }

  void setTags(List tags) {
    if (tags == [] || tags == null) {
      return;
    }

    country = tags[3];
    adminArea = tags[2];
    locality = tags[1];
    subLocality = tags[0];
  }
}

Future<Map<String, dynamic>> instaDataFromAccount(
    InstagramAccount account) async {
  Map<String, dynamic> data = {
    "profil" : account.id,
    "user_id": "07666e7a-1957-11ec-9f88-1e00620a1240",
    "userName": account.userName ?? "",
    "password": account.password ?? "",
    "pwdPassword": account.pwdPassword ?? "",
    "claim": account.claim ?? "",
    "authToken": account.authToken ?? "",
    "csrftoken": account.csrftoken ?? "",
    "rur": account.rur ?? "",
    "dsUserID": account.dsUserID ?? "",
    "sessionID": account.sessionID ?? "",
    "mid": account.mid ?? "",
    "ghost": account.ghost ?? false,
    "gender": account.gender ?? "",
    "country": account.country ?? "",
    "adminArea": account.adminArea ?? "",
    "locality": account.locality ?? "",
    "subLocality": account.subLocality ?? "",
  };
  return data;
}
