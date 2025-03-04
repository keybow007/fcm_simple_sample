import 'package:flutter/material.dart';

import '../models/firebase_manager.dart';

class ViewModel extends ChangeNotifier {
  final FirebaseManager firebaseManager;
  ViewModel({required this.firebaseManager}) {
    print("ViewModel create");
    firebaseManager.init();
  }

  String messageFromServer = "データ取得前";

  bool isProcessing = false;

  Future<void> getMessageAndSend() async {
    isProcessing = true;
    notifyListeners();

    messageFromServer = await firebaseManager.getMessage();

    isProcessing = false;
    notifyListeners();

    await firebaseManager.sendMessage(messageFromServer);

  }
}