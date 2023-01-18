import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:inmans/a1/models/user.model.dart';

/* User user(Map<String, dynamic> json) {
  return User(
    (json['user'] as List)
        ?.map((e) =>
            e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> user (User instance) =>
    <String, dynamic>{
      'user': instance.user?.map((e) => e?.toJson())?.toList(),
    };


 */

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/myuser.json');
}

Future<File> writeUserDataToLocal(userdata) async {
  final file = await _localFile;
  return file.writeAsString(jsonEncode(userdata));
}

Future<User> readUserDataFromLocal() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    
       return User.fromJson(jsonDecode(contents));
  } catch (e) {
    print(e);
    return null; //just loads a placeholder json in the assets folder;
  }
}
