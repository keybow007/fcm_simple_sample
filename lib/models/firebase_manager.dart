import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//TODO テストモードと本番との切り替え
bool isTestMode = false;

class FirebaseManager {
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /*
  * Hiroyukiのiphoneのトークン
  * d1NrStqVC0ApilvjKAdANk:APA91bGX5cVVWZF28oLJCnjPyWKVnWS0g5IHMBWAAMRugqaMh67IIcnT_QuYruK0vA94tV-g2p0pBYOoFNMx0WrKAAZi0k8CE6iR9HO7zQVqnrJwqP2dPMk
  * Androidのトークン
  * cDnnZ-JgTr2LZMr-5Zq77O:APA91bFh-VO83D6_AlugFg2roZSfVR6hCTsVWpIJc9lBxe7e3NH_vua0lHt_ff4cWF9elYvGTuJDGVPIfm8oqAiQgkNl1VyMda9H_MNSe9OaALqV-Jjc7-U
  * */
  //[送信先のデバイストークン]Androidの場合はiOS、iOSの場合はAndroidのトークンを使おう
  static String fcmTokenToSend = (Platform.isIOS)
      ? "cDnnZ-JgTr2LZMr-5Zq77O:APA91bFh-VO83D6_AlugFg2roZSfVR6hCTsVWpIJc9lBxe7e3NH_vua0lHt_ff4cWF9elYvGTuJDGVPIfm8oqAiQgkNl1VyMda9H_MNSe9OaALqV-Jjc7-U"
      : "d1NrStqVC0ApilvjKAdANk:APA91bGX5cVVWZF28oLJCnjPyWKVnWS0g5IHMBWAAMRugqaMh67IIcnT_QuYruK0vA94tV-g2p0pBYOoFNMx0WrKAAZi0k8CE6iR9HO7zQVqnrJwqP2dPMk";


  FirebaseManager() {
    init();
  }

  void init() {
    //トークンはアプリをアンインストールして再インストールしたら変わる
    FirebaseMessaging.instance
      ..requestPermission()
      ..getToken().then((token) {
        assert(token != null);
        final deviceToken = token ?? "";
        print("FCM token: $deviceToken");
      });

    //Firebaseをエミュレーターで使う設定
    //https://firebase.google.com/docs/functions/get-started?hl=ja
    if (isTestMode) functions.useFunctionsEmulator('localhost', 5001);

    //バックグラウンドでの通知受信
    // Set the background messaging handler early on, as a named top-level function
    //https://firebase.flutter.dev/docs/messaging/usage#background-messages
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //フォアグラウンドでの通知受信
    //iOSの場合の設定
    //https://firebase.flutter.dev/docs/messaging/notifications#foreground-notifications
    //この設定をやっておかないとフォアグラウンドで通知が表示されない
    // _firebaseMessaging.setForegroundNotificationPresentationOptions(
    //   alert: true, // Required to display a heads up notification
    //   badge: true, //でもこれはWorkしないぞ
    //   sound: true,
    // );


    requestPermission();
  }

  Future<String> getMessage() async {
    var callable = functions.httpsCallable('getMessageFromServer');
    final results = await callable.call();
    return results.data;
  }

  Future<void> sendMessage(String message) async {
    var callable = functions.httpsCallable('sendMessage');

    await callable.call({
      "deviceToken": fcmTokenToSend,
      "messageFromServer": message,
    });
  }

  void requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
