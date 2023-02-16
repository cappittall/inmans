import 'package:encrypt/encrypt.dart';

class InstagramAccount {
  int id;
  String userId;
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
  String shbid;
  String shbts;
  String regionHint;
  String phoneNumber;
  int countryCode;
  String email;
  int followersCount;
  String error;

  InstagramAccount({
    this.id,
    this.userId,
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
    this.shbid,
    this.shbts,
    this.regionHint,
    this.phoneNumber,
    this.countryCode,
    this.email,
    this.followersCount,
    this.error,
  });

  factory InstagramAccount.fromData(Map<String, dynamic> data) {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(data["password"], iv: iv);
    return InstagramAccount(
        id: data['id'], // database den gelen id
        userId: data["user_id"],
        userName: data["user_name"],
        password: encrypted.base64,
        pwdPassword: data["pwd_password"],
        claim: data["claim"],
        authToken: data["auth_token"],
        csrftoken: data["csrftoken"],
        rur: data["rur"],
        dsUserID: data["ds_user_id"],
        sessionID: data["session_id"],
        mid: data["mid"],
        ghost: data["ghost"],
        gender: data["gender"] ?? 'gd yok',
        shbid: data["shbid"],
        shbts: data["shbts"],
        regionHint: data["region_hint"],
        phoneNumber: data["phone_number"],
        countryCode: data["country_code"],
        email: data["email"],
        followersCount: data["followers_count"],
        error: data["error"]??'');
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
    "profil": account.id,
    "user_id": "07666e7a-1957-11ec-9f88-1e00620a1240",
    "user_name": account.userName ?? "",
    "password": account.password ?? "",
    "pwd-password": account.pwdPassword ?? "",
    "claim": account.claim ?? "",
    "auth_token": account.authToken ?? "",
    "csrftoken": account.csrftoken ?? "",
    "rur": account.rur ?? "",
    "ds_user_id": account.dsUserID ?? "",
    "session_id": account.sessionID ?? "",
    "mid": account.mid ?? "",
    "ghost": account.ghost ?? false,
    "gender": account.gender ?? "",
    "country": account.country ?? "",
    "adminArea": account.adminArea ?? "",
    "locality": account.locality ?? "",
    "subLocality": account.subLocality ?? "",
    "shbid": account.shbid ?? "",
    "shbts": account.shbts ?? "",
    "regionHint": account.regionHint ?? "",
    "phone_number": account.phoneNumber ?? "",
    "country_code": account.countryCode ?? 0,
    "email": account.email ?? "",
    "followers_count": account.followersCount ?? 0,
    "error": account.error ?? "",
  };
  return data;
}
