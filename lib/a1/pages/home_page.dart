import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:togetherearn/a1/pages/register_page.dart';
import 'package:togetherearn/main.dart';
import 'package:togetherearn/a1/models/local.model.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:carousel_slider/carousel_slider.dart';

import 'package:hive/hive.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:togetherearn/a1/pages/pages.dart';
import 'package:togetherearn/a1/instagramAccounts/globals.dart';
import 'package:togetherearn/a1/localization/language_controller.dart';
import 'package:togetherearn/a1/utils/constants.dart';
import 'package:togetherearn/a1/utils/multilang.dart';
import 'package:togetherearn/a1/utils/navigate.dart';
import 'package:togetherearn/a1/widgets/background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:togetherearn/a1/models/user.model.dart';
import '../server/values.dart';
import '../services/location/location_manager.dart';
import 'balance.dart';
import 'package:togetherearn/main.dart';

import 'package:togetherearn/a1/instagramAccounts/instagram_interractions.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:easy_localization/easy_localization.dart';

import '../instagramAccounts/server/server.dart';
import '../models/instagram_account.model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  User user;
  bool signedIn = false;

  bool connected = false;
  List<MostEarner> mostEarnings;
  List<DrawerItem> drawerItems;
  StreamSubscription<Position> subscription;
  List accounts;
  Timer timer;
  IOWebSocketChannel channel;
  InstagramInterractions interractions = InstagramInterractions();
  List imgList = [];
  List imgNames = [];
  String headline;
  Map<String, dynamic> place;

  LanguageController languageController = LanguageController();
  @override
  void initState() {
    super.initState();
    initDrawer();

    // getImageUrls from server in order to serve in corasel
    _getImageUrls();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    Future.delayed(Duration.zero, () async {
      await Server.getDeviceInfo(context);
      await Server.generateIDs();
    });
  }

  void _init() async {
    await connectToSocket();
    await getServerToken();
    await loadPriceData();

    user = await initUserState();

    Locale myLocale = Localizations.localeOf(context);
    setState(() {
      signedIn = user != null;
      cCode = myLocale.toString();
      print("cCode: $cCode");
    });

    // create a new isolate for the function
    // final myIsolate = await Isolate.spawn(_isolateFunction, null);
    listenLocaiton(user);

    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => sendDataToWebSocket(place));
  }

  /*  Future<String> downloadImage({String url, String fileName}) async {
    var response = await http.get(Uri.parse(url));
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var folderPath = documentsDirectory.path + "/mostEarnerImages";
    var filePath = folderPath + "/$fileName.jpg".replaceAll(" ", "_");
    if (!Directory(folderPath).existsSync()) {
      await Directory(folderPath).create(recursive: true);
    }
    File image = File(filePath);
    await image.writeAsBytes(response.bodyBytes);

    return image.path;
  } */

  Map getAccountPrices(int followersCount) {
    Map price;
    // 500
    for (var item in prices) {
      int min = int.parse(item['followerCount'].split('-')[0]);
      int max = min == 5000
          ? 99000000
          : int.parse(item['followerCount'].split('-')[1]);
      if (min <= followersCount && followersCount <= max) {
        price = item;
        break;
      }
    }
    return price;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    idOp();
  }

  void idOp() async {
    await Server.getDeviceInfo(context);
    Server.generateIDs();
  }

  /// added for locationSettins değişkeni
  LocationSettings locationSettings = defaultTargetPlatform ==
          TargetPlatform.android
      ? AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1200),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationText:
                  "Şuan kazanmaya devam ediyorsunuz. çünkü instagram hesaplarınız aktif ve uygulamanız arka planda çalışıyor.",
              notificationTitle: "Running in Background")
          //enableWakeLock: true,
          )
      : defaultTargetPlatform == TargetPlatform.iOS
          ? AppleSettings(
              accuracy: LocationAccuracy.high,
              activityType: ActivityType.fitness,
              distanceFilter: 100,
              pauseLocationUpdatesAutomatically: true,
              // Only set to true if our app will be started up in the background.
              showBackgroundLocationIndicator: false,
            )
          : const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 100,
            );

  Future<Map<String, dynamic>> listenLocaiton(User user) async {
    if (user == null) return {"lat": 0, "long": 0};
    while (true) {
      await LocationManager.checkPermission();
      if (LocationManager.canUseLocation()) {
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
          if (position != null) {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            Map<String, dynamic> userData = userDataFromUser(user);

            if (placemarks.isNotEmpty && position != null) {
              place = placemarks[0].toJson();
              place['lat'] = position.latitude;
              place['long'] = position.longitude;
            }
            userData['profil']['place'] = place;
            print('>>> Userdatap place ${userData['profil']['place']}');
            writeUserDataToLocal(userData);
            // headers
            Map<String, String> header = {
              "Content-Type": "application/json; charset=UTF-8",
              "Authorization": "Token ${userData['profil']['token']}"
            };
            //Databaseden de değiştir..
            http.Response response = await http.patch(
                Uri.parse("$conUrl/api/profil/${userData['profil']['id']}/"),
                body: jsonEncode(userData['profil']),
                headers: header);

            user = User.fromJson(userData);
          }
        });
      }

      if (place != null) {
        break;
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(
            context, getString("winMoreWithLocation"), Colors.redAccent);
        await Future.delayed(Duration(seconds: 15));
      }
    }
    return {"lat": place['lat'] ?? 0, "long": place['long'] ?? 0};
  }

  void sendDataToWebSocket(place) {
    if (user == null) return;
    Map<String, dynamic> data = {
      'action': 'mobileLocation',
      'message': place.toString(),
      'sender': user.id,
      'receivers': [0]
    };
    channel.sink.add(jsonEncode(data)); // to be implemented
  }

  shelf.Response _echoRequest(shelf.Request request) =>
      shelf.Response.ok('Request for localhost:8080 "${request.url}"');

  void handleGeneralWebsocketMessages(msg) async {
    print('>>> General websocket message ${msg}');
    var msgm = msg['message'];
    if (msgm['action'] == 'versionUpdate') {
      print('>>> Version update başlasın $msgm');
      // restart the app
    } else {
      print('>>> Version update başlaMAn $msgm');
    }
    Phoenix.rebirth(context);
  }

// websocket için
  void handleWebsocketMessages(msg) async {
    Map<String, dynamic> profil = user.profil;

    var accounts = profil['instagram'].map((x) => InstagramAccount.fromData(x));
    if (accounts.length == 0) {
      // ignore: use_build_context_synchronously
      showSnackBar(
          context, getString("addInstagramAccountToStart"), Colors.redAccent);
    } else {
      accounts.forEach((account) async {
        Map accountPriceList = await getAccountPrices(account.followersCount);
        var returnData;
        await interractions
            .interactWithInstagramApi(
                msg['message'], account, accountPriceList, profil)
            .then((resp) {
          if (resp['error'] != null) {
            print('Error varrr .${account.userName} - ${resp['error']}');

            profil['instagram'].forEach((x) {
              if (x['id'] == account.id) {
                x['error'] = resp['error'];
              }
            });
            setState(() {
              account.error = resp['error'];
            });
            writeUserDataToLocal(userDataFromUser(user));
            // ignore: use_build_context_synchronously
            showSnackBar(
                context,
                "${getString(resp['error'])} ${account.userName}",
                Colors.redAccent,
                isLong: true);
          } else {
            returnData = {
              'action': 'mobileAction',
              'message': resp.toString(),
              'sender': user.id,
              'receivers': [0]
            };
            return channel.sink.add(jsonEncode(returnData));
          }
        });
      });
    }
  }

  void connectToSocket() async {
    channel = IOWebSocketChannel.connect(Uri.parse(socketUrl),
        headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'});

    StreamController<String> streamController =
        StreamController.broadcast(sync: true);
    channel.stream.listen((event) async {
      //Check if event comes not from this user
      var msg = jsonDecode(event)['message'];
      // streamController.add(event);

      if (msg['action'] == 'serverAction' && user != null) {
        if (msg['receivers'].contains(user.id)) {
          handleWebsocketMessages(msg);
        } else if (msg['receivers'].contains(0)) {
          handleGeneralWebsocketMessages(msg);
        }
      }
    }, onDone: () async {
      print("conecting aborted, Reconnecting...");
      await Future.delayed(const Duration(seconds: 50));
      channel.sink.close();
      connectToSocket();
    }, onError: (e) async {
      print(
          'Server error: $e Reconnecting ... \n${status.internalServerError}');
      await Future.delayed(const Duration(seconds: 60));
      channel.sink.close();
      connectToSocket();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    channel.sink.close();
  }

  void initDrawer() {
    drawerItems = [
      DrawerItem(
          title: getString("account"),
          icon: Icons.person,
          target: AccountPage()),
      DrawerItem(
          title: getString("settings"),
          icon: Icons.settings,
          target: SettingsPage()),
/*       DrawerItem(
          title: getString("products"),
          icon: Icons.menu_book,
          target: ProductsPage()), */
      DrawerItem(
          title: getString("balance"),
          icon: Icons.monetization_on,
          target: BalancePage()),
/*       DrawerItem(
          title: getString("bills"),
          icon: Icons.receipt,
          target: const Bills()), */
      DrawerItem(
          title: getString("penalties"),
          icon: Icons.close,
          target: PenaltiesPage()),
      DrawerItem(
          title: getString("instaAccounts"),
          icon: Icons.person,
          target: InstagramAccounts()),
    ];

    if (Platform.isAndroid) {
      drawerItems.insert(
          3,
          DrawerItem(
              title: getString("earningTable"),
              icon: Icons.table_chart,
              target: EarningTablePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromARGB(255, 132, 16, 8),
        drawer: Drawer(
          child: Container(
            color: const Color(0xFF913248),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Text("Together Earn |",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    height: 0.5,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: ListView(padding: EdgeInsets.zero, children: [
                    ...drawerItems.map((drawerItem) {
                      return CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: Center(
                                        child: Icon(
                                          drawerItem.icon,
                                          color: kMainColor,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      drawerItem.title,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 0.5,
                                color: Colors.grey,
                                width: double.infinity,
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (signedIn ||
                                drawerItem.title == getString("settings")) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => drawerItem.target,
                                      settings:
                                          RouteSettings(arguments: user)));

                              setState(() {
                                // set language
                                initDrawer();
                              });
                            } else {
                              showSnackBar(context, getString("notSignedIn"),
                                  Colors.redAccent);
                            }
                          });
                    }).toList(),
                    CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        onPressed: _signOut,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                      child: Icon(
                                        Icons.logout,
                                        color: kMainColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    getString("logOut"),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.grey,
                              width: double.infinity,
                            ),
                          ],
                        )),
                  ]),
                ),
                RichText(
                  text: TextSpan(
                      text: getString("privacyPolicy"),
                      style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: 18),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          launchUrl(Uri.parse('$conUrl/api/privacy-policy/'));
                        }),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 30,
              ),
            );
          }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Together Earn | '),
              Expanded(
                  child: Text(signedIn ? "${user.email.split('@')[0]} | " : "",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15))),
              Expanded(
                child: InkWell(
                  onTap: () {/* Handle tap event */},
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.zero,
                              child: IconButton(
                                icon: Icon(signedIn
                                    ? Icons.exit_to_app
                                    : Icons.account_circle),
                                onPressed: () async {
                                  /* Handle press event */
                                  // if not signed in, go to login page
                                  if (signedIn) {
                                    _signOut();
                                  } else {
                                    user = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                    if (user != null) {
                                      setState(() {
                                        signedIn = true;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  signedIn
                                      ? getString('logout')
                                      : getString('login'),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getString("mostEarnings"),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ]),
                  ),
                ),
                // insert space here
                const SizedBox(
                  height: 30,
                ),
                // insert slider here at main screen
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 9 / 10,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: imgList.map((imgUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Stack(
                            children: [
                              Image.network(imgUrl),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 80, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // get index of image
                                        "${imgNames[imgList.indexOf(imgUrl)].split(',')[0]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "${getString("balance")}: ",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "\$${imgNames[imgList.indexOf(imgUrl)].split(',')[1]}",
                                            style: const TextStyle(
                                              color: Colors.greenAccent,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImageUrls() async {
    final response = await http.get(Uri.parse('$conUrl/get_image_urls/'));
    if (response.statusCode == 200) {
      var body = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      print("$body , ${body.runtimeType}");
      List<dynamic> urlList = body['urls'];
      urlList.forEach((element) {
        imgList.add(domainUrl + element.split('django_instagram2')[1]);
        print(element);
      });
      imgNames = body['names'];
      print("Image urls ve names: \n $imgList, \n $imgNames");
      setState(() {});
    } else {
      throw Exception('Failed to load image URLs');
    }
  }

  void _signOut() async {
    var userBox = await Hive.openBox('localUser');
    await userBox.clear();
    await localDataBox.clear();
    setState(() {
      signedIn = false;
    });
  }

  getMostEarners() async {
    // get most earners picture from phones's documentsDirectory.path + "/mostEarnerImages" images for slider

    http.Response response =
        await http.get(Uri.parse('$conUrl/api/mostearners/'), headers: headers);
    return json.decode(utf8.decode(response.bodyBytes))['results'];
  }
}

class QueryDocumentSnapshot {
  get(String s) {}
}

class DrawerItem {
  String title;
  Widget target;
  IconData icon;

  DrawerItem({this.target, this.title, this.icon});
}

class MostEarner {
  String name;
  double earning;
  String image;

  MostEarner({this.name, this.earning, this.image, user});
}

/* 
Expanded(
                  child: Text(
                      signedIn ? getString('logout') : getString('login'),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15))),
              Expanded(
                child: IconButton(
                  icon:
                      Icon(signedIn ? Icons.exit_to_app : Icons.account_circle),
                  onPressed: () async {
                    // if not signed in, go to login page
                    if (signedIn) {
                      _signOut();
                    } else {
                      user = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                      if (user != null) {
                        setState(() {
                          signedIn = true;
                        });
                      }
                    }
                  },
                ),
              ), 
*/