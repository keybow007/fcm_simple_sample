import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/view_model.dart';

/*
* ボタンを押したら、
* １）Functionsでサーバーからデータを取得して、
* ２）その値を別のFunctionsでサーバーに投げて
* ３）FCM経由で通知（フォアグラウンド・バックグラウンド両方）
*   実機のtokenIdをFCMの初期化に取得しておく
* */

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () => _getAndSendMessage(context),
      ),
      body: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          final messageFromServer = viewModel.messageFromServer;
          final isProcessing = viewModel.isProcessing;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: (isProcessing) ? CircularProgressIndicator() : Container(
                child: Text(messageFromServer),
              ),
            ),
          );
        },
      ),
    );
  }

  _getAndSendMessage(BuildContext context) async {
    print("_getAndSendMessage");
    final viewModel = context.read<ViewModel>();
    viewModel.getMessageAndSend();
  }
}
