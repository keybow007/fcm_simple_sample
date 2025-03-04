/*
* Cloud FunctionsとFCMの超シンプルなサンプル（FirebaseのプロジェクトはFirebaseSamplesで）
* => ボタンを押したらCloudFunctions投げてFCMで通知（Foreground/Background両方）
*
* Cloud Functions（使うためにはFirebaseをBlazeプランにアップグレード要）
* （Firebase公式1：CloudFunctionsの仕組み：関数はStorageにアップされる）
* https://firebase.google.com/docs/functions/
* （Firebase公式2：関数の作り方・サーバーへのアップ方法（テストはFirebaseエミュレーターでやること）
* https://firebase.google.com/docs/functions/get-started
* （Firebase公式3：Firebaseエミュレーターの使い方）
* https://firebase.google.com/docs/emulator-suite
*
* iOSはTargetレベルを10.12以上に
*
* (Flutter公式：こっちはサーバーに上げた関数のアプリ側（クライアント側）からの呼び出し方を説明）
* https://firebase.flutter.dev/docs/functions/overview
*
* FCM
* https://firebase.flutter.dev/docs/messaging/overview
*
* FirebaseFlutterスタートガイド
* https://firebase.flutter.dev/docs/overview
* */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/firebase_manager.dart';
import 'view_models/view_model.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => FirebaseManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewModel(
            firebaseManager: context.read<FirebaseManager>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
