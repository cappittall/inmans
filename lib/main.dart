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
import 'a1/services/location/location_manager.dart';

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
  initializeDateFormatting('tr', null)
      .then((_) => runApp(const togetherearn()));
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
                    Locale("tr"),
                    Locale("en"),
                  ];
                  print('Snapshot:  ${snapshot.hasData}');
                  if (signedIn == null) {
                    return const SplashScreen();
                  } else {
                    return HomePage();
                  }
                })));
  }
}
