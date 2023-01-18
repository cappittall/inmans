import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:inmans/a1/pages/pages.dart';
import 'package:inmans/a1/pages/splah.dart';
import 'package:inmans/a1/models/instagram_account.model.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';
import 'package:inmans/a1/localization/language_controller.dart';
import 'package:inmans/services/location/location_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'a1/models/user.model.dart';

bool emulator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* HttpOverrides.global = new MyHttpOverrides();
  await Hive.initFlutter(); */

  await Hive.initFlutter();

  localDataBox = await Hive.openBox('localDataBox');
  localUser = await Hive.openBox('localUser');
  languageController.initialize();

  LocationManager.initializeLocation();
  initializeDateFormatting('tr_TR', null).then((_) => runApp(const Inmans()));
} 

class Inmans extends StatefulWidget {
  const Inmans({Key key}) : super(key: key);

  @override
  State<Inmans> createState() => _InmansState();
}

class _InmansState extends State<Inmans> {
  _InmansState();

  User user;
  bool signedIn;

  bool verificationRequired;
  void checkVersion() async {}

  @override
  void initState() {
    languageController.addListener(() {});

    super.initState();
  }

  Future<User> _init() async {
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
                  locale:
                  Locale(languageController.getLocale());
                  theme:
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
                    Locale("tr"),
                    Locale("en"),
                  ];
                  print('Snapshot:  ${snapshot.hasData}');
                  if (signedIn == null) {
                    return const SplashScreen();
                  } else  {
                    return HomePage();
                  }

                })));
  }
}
