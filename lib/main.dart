import 'dart:convert';
import 'dart:io';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:togetherearn/a1/pages/pages.dart';
import 'package:togetherearn/a1/pages/splah.dart';
import 'package:togetherearn/a1/instagramAccounts/globals.dart';
import 'package:togetherearn/a1/localization/language_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
import 'a1/models/user.model.dart';
import 'a1/pages/version.dart';
import 'a1/services/location/location_manager.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'a1/utils/constants.dart';

bool emulator;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  await Hive.initFlutter();

  localDataBox = await Hive.openBox('localDataBox');
  localUser = await Hive.openBox('localUser');
  languageController.initialize();

  LocationManager.initializeLocation();
  initializeDateFormatting('tr', null)
      // Phoenix is a package that allows you to restart the app
      .then((_) => runApp(Phoenix(child: togetherearn())));
}

class togetherearn extends StatefulWidget {
  const togetherearn({Key key}) : super(key: key);

  @override
  State<togetherearn> createState() => _togetherearnState();
}

class _togetherearnState extends State<togetherearn> {
  _togetherearnState();

  User user;
  bool signedIn;
  bool versionFailed;
  bool verificationRequired;
  void checkVersion() async {}

  @override
  void initState() {
    languageController.addListener(() {});

    super.initState();
  }

  Future<User> _init() async {
    // check version from pubspec.yaml
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = '${packageInfo.version}.${packageInfo.buildNumber}';
    var response = await http.get(Uri.parse('$conUrl/api/versioncontrol/'));
    var ver = jsonDecode(utf8.decode(response.bodyBytes))['results'][0];

    print('Response:${ver['version']} - ${ver.runtimeType}');
    if (version != ver['version']) {
      print('Version: ${packageInfo.version}');
      print('Version: ${packageInfo.buildNumber}');
      versionFailed = true;
      // direct user to playstore
    } else {
      versionFailed = false;
    }
    // ignore: void_checks
    user = await initUserState();
    signedIn = user != null ? true : false;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    print('Signedin in Main.dart >>>>>>>$signedIn');
    return MaterialApp(

        title: "Together Earn  ",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: FutureBuilder<User>(
                future: _init(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  Locale(languageController.getLocale());
                  ThemeData(
                    unselectedWidgetColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                  localizationsDelegates:
                  const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ];
                  supportedLocales:
                  const [
                    Locale('en', 'US'),
                    Locale('tr', 'TR'),
                  ];
                  print('Snapshot:  ${snapshot.hasData}');
                  if (signedIn == null) {
                    return const SplashScreen();
                  } else if (versionFailed) {
                    return const VersionFailed();
                  } else {
                    return HomePage();
                  }
                })));
  }
}
