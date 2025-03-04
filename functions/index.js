//VS CodeでのソースジャンプはF12

// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
//第一世代は'firebase-functions/v1'にしないといけなくなったらしい
//https://stackoverflow.com/a/79285376/7300575
const functions = require('firebase-functions/v1');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

//関数のリージョンを変更する（デフォルトのus-central1ではうまくいかないケースあり）
//Unhandled Exception: [firebase_functions/permission-denied] PERMISSION DENIED
//https://dhtrtr.blogspot.com/2018/08/firebase-cloud-functions-firestore.html
//https://firebase.google.com/docs/functions/manage-functions?hl=ja#modify-region

exports.getMessageFromServer = functions.https.onCall((data, context) => {
  console.log('getMessageFromServerが呼ばれたで〜');
  return "サーバーからデータを取得しました"
});

// exports.getMessageFromServerFromAsia = functions.region('asia-northeast2').https.onCall((data, context) => {
//   console.log('getMessageFromServerが呼ばれたで〜');
//   return "サーバーからデータを取得しました"
// });

exports.sendMessage = functions.https.onCall((data, context) => {
  console.log('sendMessageが呼ばれたで〜');
  const token = data.deviceToken;
  const messageContent = data.messageFromServer;

  console.log('token:', token);
  console.log('messageContent:', messageContent);

  var message = {
    //メッセージの形
    //https://firebase.google.com/docs/cloud-messaging/concept-options?hl=ja
    //https://firebase.flutter.dev/docs/messaging/notifications#via-admin-sdks
    token: token,
    notification: {
      title: "通知",
      body: messageContent,
    },
    //バックグラウンドでBadgeをつける方法（iOS）
    //https://stackoverflow.com/a/56989999
    //https://firebase.google.com/docs/cloud-messaging/concept-options#data_messages
    apns: {
      payload: {
        aps: {
          badge: 100
        }
      }
    }
  }

  admin.messaging().send(message).then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
    return null;
  })
    .catch((error) => {
      console.log('Error sending message:', error);
    });

  //最後はreturn 0にしておかないとエラーになる
  return 0
});

// exports.sendMessageFromAsia = functions.region('asia-northeast2').https.onCall((data, context) => {
//   console.log('sendMessageが呼ばれたで〜');
//   const token = data.deviceToken;
//   const messageContent = data.messageFromServer;

//   console.log('token:', token);
//   console.log('messageContent:', messageContent);

//   var message = {
//     //メッセージの形
//     //https://firebase.google.com/docs/cloud-messaging/concept-options?hl=ja
//     //https://firebase.flutter.dev/docs/messaging/notifications#via-admin-sdks
//     token: token,
//     notification: {
//       title: "通知",
//       body: messageContent,
//     },
//     //バックグラウンドでBadgeをつける方法（iOS）
//     //https://stackoverflow.com/a/56989999
//     //https://firebase.google.com/docs/cloud-messaging/concept-options#data_messages
//     apns: {
//       payload: {
//         aps: {
//           badge: 100
//         }
//       }
//     }
//   }

//   admin.messaging().send(message).then((response) => {
//     // Response is a message ID string.
//     console.log('Successfully sent message:', response);
//     return null;
//     })
//     .catch((error) => {
//         console.log('Error sending message:', error);
//     });

//   //最後はreturn 0にしておかないとエラーになる
//   return 0
// });



