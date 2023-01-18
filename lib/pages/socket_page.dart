import 'dart:async';
import 'dart:io';
import 'package:inmans/a1/utils/constants.dart';


//implement it later
// https://stackoverflow.com/questions/55503083/flutter-websockets-autoreconnect-how-to-implement

class NotificationController {

  static final NotificationController _singleton = NotificationController._internal();

  StreamController<String> streamController = StreamController.broadcast(sync: true);

  String wsUrl = socketUrl;

  WebSocket channel;

  factory NotificationController() {
    return _singleton;
  }

  NotificationController._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {

    channel = await connectWs();
    channel.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() {
    channel.listen((streamData) {
      streamController.add(streamData);
    }, onDone: () {
      print("conecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('Server error: $e');
      initWebSocketConnection();
    });
  }

  connectWs() async{
    try {
      return await WebSocket.connect(socketUrl);
    } catch  (e) {
      print("Error! can not connect WS connectWs " + e.toString());
      await Future.delayed(const Duration(milliseconds: 10000));
      return await connectWs();
    }

  }

  void _onDisconnected() {
    initWebSocketConnection();
  }
}

