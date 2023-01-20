import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:togetherearn/a1/pages/register_page.dart';
import 'package:togetherearn/a1/utils/constants.dart';
import 'package:togetherearn/a1/models/local.model.dart';
import 'package:togetherearn/a1/models/user.model.dart';

import '../utils/multilang.dart';

class User {
  int id;
  String username;
  String password;
  String token;
  String first_name;
  String last_name;
  String email;
  String phone;
  String bank;
  String iban;
  String tc;
  DateTime birth_date;
  Object info;
  Object profil;

  User(
      {this.id,
      this.username,
      this.password,
      this.token,
      this.first_name,
      this.last_name,
      this.email,
      this.phone,
      this.bank,
      this.iban,
      this.tc,
      this.birth_date,
      this.info,
      this.profil});

  factory User.fromJson(json) {
    // ignore: unrelated_type_equality_checks
    return User(
      id: json['id'],
      username: json['username'],
      token: json['profil']['token'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      profil: json['profil'] ?? {},
    );
  }

  User.toLocal(data) {
    var userBox = Hive.box('localUser');
    userBox.put("id", data['id']);
    userBox.put("token", data['profil']['token']);
  }
}

Map<String, dynamic> userDataFromUser(user) {
  Map<String, dynamic> userData = {
    'id': user.id,
    'username': user.username,
    'token': user.token,
    'first_name': user.first_name,
    'last_name': user.last_name,
    'email': user.email,
    'profil': user.profil
  };
  return userData;
}

class UserLogin {
  String username;
  String password;

  UserLogin({this.username, this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"username": username, "password": password};
}

// Check user exist on localdrive or not.
Future<User> initUserState() async {
  var userBox = Hive.box('localUser');
  if (userBox.isNotEmpty) {
    return await readUserDataFromLocal();
  } else {
    return null;
  }
}

Future<User> createUpdateUser(body, bool updateServer, user, context) async {
  var urls =
      updateServer ? "$conUrl/api/users/${user.id}/" : "$conUrl/api/users/";
  http.Response response;

  String mess = 'Sonuç :';
  if (updateServer) {
    Map<String, String> header = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Token ${user.profil['token']}"
    };
    mess += '>>>>>> Update ediliyor: $updateServer, $header \n$urls \n$body';
    // Update user from server
    response = await http.patch(Uri.parse(urls),
        headers: header, // user own header
        body: jsonEncode(body));
  } else {
    mess +=
        '>>>>>>Yeni kayıt \n$urls  \n$headers \n$body \n${body.runtimeType}';
    response = await http.post(
      Uri.parse(urls),
      body: jsonEncode(body),
      headers: headers, // Superuser header
    );
  }

  print(jsonDecode(utf8.decode(response.bodyBytes)));

  var userData = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

  print(mess);
  print('Dönen kayıt $userData');

  if (response.statusCode == 200 || response.statusCode == 201) {
    writeUserDataToLocal(userData); // Write incoming data from server.
    User.toLocal(userData);
    User user = User.fromJson(userData);
    return user;
  }
  if (userData['username'][0]
      .contains('A user with that username already exists')) {
    showSnackBar(context, getString("emailExists"), Colors.redAccent);
    return null;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create user. ${jsonDecode(response.body)}');
  }
}

Future<User> signIn(String email, String password, BuildContext context) async {
  // uses dj-rest-auth api
  Map<String, String> body = {'username': email, 'password': password};
  const url = "$conUrl/api-token-auth/";
  print('Sign in $url');

  http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  print('Loginden: ${response.statusCode}');

  Map<String, dynamic> userData = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    print('Login den data ${userData} Bundan sonrası hata verebilir. ');
    writeUserDataToLocal(userData); // Write incoming data from server.
    User.toLocal(userData);
    User user = User.fromJson(userData);

    return user;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create user. ${jsonDecode(response.body)}');
  }
}
