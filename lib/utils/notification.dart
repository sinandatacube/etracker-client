// // import 'dart:convert';
// // import 'dart:developer';

// // import 'package:etracker_client/utils/utils.dart';
// // import 'package:etracker_client/views/task/task.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class NotificationServices {
// //   //local
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //   var androidInitilize =
// //       const AndroidInitializationSettings('@drawable/ic_stat_name');
// //   var iOSinitilize = const IOSInitializationSettings();
// //   static AndroidNotificationChannel channel = const AndroidNotificationChannel(
// //     'high_importance_channel', // id
// //     'High Importance Notifications', // title
// //     importance: Importance.max,
// //   );

// //   //fcm
// //   final firebaseMessaging = FirebaseMessaging.instance;
// //   late final SharedPreferences? sharedPreferences;

// //   // It is assumed that all messages contain a data field with the key 'type'
// //   Future<void> setupInteractedMessage() async {
// //     initializeSettings();
// //     await firebaseMessaging.subscribeToTopic("spencer_user");

// //     await firebaseMessaging.setForegroundNotificationPresentationOptions(
// //       alert: true, // Required to display a heads up notification
// //       badge: true,
// //       sound: true,
// //     );
// //     // Get any messages which caused the application to open from
// //     // a terminated state.
// //     RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

// //     // If the message also contains a data property with a "type" of "chat",
// //     // navigate to a chat screen
// //     if (initialMessage != null) {
// //       _handleMessage(initialMessage);
// //     }

// //     // Also handle any interaction when the app is in the background via a
// //     // Stream listener
// //     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       RemoteNotification? notification = message.notification;
// //       AndroidNotification? android = message.notification?.android;

// //       // If `onMessage` is triggered with a notification, construct our own
// //       // local notification to show to users using the created channel.
// //       if (notification != null && android != null) {
// //         Map notifData = message.data;
// //         String payload = jsonEncode(notifData);
// //         showLocalNotif(
// //           notification.hashCode,
// //           notification.title ?? "Unknown title",
// //           notification.body ?? "Unknown description",
// //           payload,
// //         );
// //       }
// //     });
// //   }

// //   //navigate
// //   void _handleMessage(RemoteMessage message) async {
// //     log(message.data.toString());
// //     if (message.data['type'] == 'Car Purchase') {
// //       // const LoadingAnimation();
// //       log(message.data.toString());

// //       String orderId = message.data["click_id"];
// //       try {
// //         // Map body = {'order_id': orderId};
// //         // http.Response response =
// //         // await http.post(Uri.parse("${path}order_details"), body: body);
// //         // var result = await jsonDecode(response.body);
// //         navigatorKey.currentState!.push(
// //           MaterialPageRoute(
// //             builder: (context) => Task(
// //                 // purchaseId: orderId,
// //                 ),
// //           ),
// //         );
// //       } catch (e) {
// //         log('Error $e');
// //         navigatorKey.currentState?.pop();
// //       }
// //     }
// //     // if (message.data['type'] == 'Offer') {
// //     //   String productId = message.data["click_id"];
// //     //   navigatorKey.currentState?.push(
// //     //     MaterialPageRoute(
// //     //       builder: (_) => VehicleDetails(
// //     //         purchaseId: productId,
// //     //       ),
// //     //     ),
// //     //   );
// //     // }
// //   }

// //   showLocalNotif(int id, String title, String description, String payload) {
// //     var androidDetails = const AndroidNotificationDetails(
// //         "high_importance_channel", "High Importance Channel",
// //         importance: Importance.max);
// //     var iSODetails = const IOSNotificationDetails(
// //       presentAlert: true, // Required to display a heads up notification
// //       presentBadge: true,
// //       presentSound: true,
// //     );
// //     var notificationDetails =
// //         NotificationDetails(android: androidDetails, iOS: iSODetails);
// //     flutterLocalNotificationsPlugin
// //         .show(id, title, description, notificationDetails, payload: payload);
// //   }

// //   initializeSettings() async {
// //     var initilizationsSettings =
// //         InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
// //     flutterLocalNotificationsPlugin.initialize(
// //       initilizationsSettings,
// //       onSelectNotification: onSelectNotification,
// //     );
// //     flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>()
// //         ?.requestPermission();
// //     await flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>()
// //         ?.createNotificationChannel(channel);
// //   }

// //   Future onSelectNotification(String? payload) async {
// //     log(payload.toString());
// //     if (payload != null) {
// //       log('notification_payload: $payload');
// //       Map data = jsonDecode(payload);
// //       if (data.isNotEmpty) {
// //         String clickId = data["click_id"];
// //         String type = data["type"];
// //         if (clickId.isNotEmpty && clickId != "0") {
// //           if (type == "Car Purchase") {
// //             try {
// //               navigatorKey.currentState?.push(
// //                 MaterialPageRoute(
// //                   builder: (context) => Task(
// //                       // purchaseId: clickId,
// //                       ),
// //                 ),
// //               );
// //             } catch (e) {
// //               log('Error $e');
// //             }
// //           }

// //           // if (type == "Car Sale") {
// //           //   String id = clickId;
// //           //   navigatorKey.currentState?.push(
// //           //     MaterialPageRoute(
// //           //       builder: (_) => Product(productId: id),
// //           //     ),
// //           //   );
// //           // }
// //         }
// //       }
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'dart:developer';

// import 'package:etracker_client/utils/utils.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationServices {
//   //local
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   var androidInitilize =
//       const AndroidInitializationSettings('@drawable/ic_stat_name');
//   var iOSinitilize = const IOSInitializationSettings();
//   static AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.max,
//   );

//   //fcm
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   final firebaseMessaging = FirebaseMessaging.instance;
//   late final SharedPreferences? sharedPreferences;

//   // It is assumed that all messages contain a data field with the key 'type'
//   Future<void> setupInteractedMessage() async {
//     initializeSettings();
//     await firebaseMessaging.subscribeToTopic("spencer_user");

//     await firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }

//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       // If `onMessage` is triggered with a notification, construct our own
//       // local notification to show to users using the created channel.
//       if (notification != null && android != null) {
//         Map notifData = message.data;
//         String payload = jsonEncode(notifData);
//         showLocalNotif(
//           notification.hashCode,
//           notification.title ?? "Unknown title",
//           notification.body ?? "Unknown description",
//           payload,
//         );
//       }
//     });
//   }

//   Future<void> onBackgroundMessage(RemoteMessage message) async {
//     log("Handling a background message: ${message}");
//   }

//   //navigate
//   void _handleMessage(RemoteMessage message) async {
//     if (message.data['type'] == 'Order') {
//       // const LoadingAnimation();
//       log(message.data.toString());

//       String orderId = message.data["click_id"];
//       try {
//         // Map body = {'order_id': orderId};
//         // http.Response response =
//         // await http.post(Uri.parse("${path}order_details"), body: body);
//         // var result = await jsonDecode(response.body);
//         // navigatorKey.currentState!.push(
//         //   MaterialPageRoute(
//         //     builder: (context) => OrderDetails(
//         //       orderId: orderId,
//         //     ),
//         //   ),
//         // );
//       } catch (e) {
//         log('Error $e');
//         navigatorKey.currentState?.pop();
//       }
//     }
//     if (message.data['type'] == 'Offer') {
//       String productId = message.data["click_id"];
//       // navigatorKey.currentState?.push(
//       //   MaterialPageRoute(
//       //     builder: (_) => Product(
//       //       productId: productId,
//       //     ),
//       //   ),
//       // );
//     }
//   }

//   showLocalNotif(int id, String title, String description, String payload) {
//     var androidDetails = const AndroidNotificationDetails(
//         "high_importance_channel", "High Importance Channel",
//         importance: Importance.max);
//     var iSODetails = const IOSNotificationDetails(
//       presentAlert: true, // Required to display a heads up notification
//       presentBadge: true,
//       presentSound: true,
//     );
//     var notificationDetails =
//         NotificationDetails(android: androidDetails, iOS: iSODetails);
//     flutterLocalNotificationsPlugin
//         .show(id, title, description, notificationDetails, payload: payload);
//   }

//   initializeSettings() async {
//     var initilizationsSettings =
//         InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
//     flutterLocalNotificationsPlugin.initialize(
//       initilizationsSettings,
//       onSelectNotification: onSelectNotification,
//     );
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future onSelectNotification(String? payload) async {
//     if (payload != null) {
//       log('notification_payload: $payload');
//       Map data = jsonDecode(payload);
//       if (data.isNotEmpty) {
//         String clickId = data["click_id"];
//         String type = data["type"];
//         if (clickId.isNotEmpty && clickId != "0") {
//           if (type == "Order") {
//             try {
//               // navigatorKey.currentState?.push(
//               //   MaterialPageRoute(
//               //     builder: (context) =>
//               //   ),
//               // );
//             } catch (e) {
//               log('Error $e');
//             }
//           }

//           if (type == "Offer") {
//             // String id = clickId;
//             // navigatorKey.currentState?.push(
//             //   MaterialPageRoute(
//             //     builder: (_) => Product(productId: id),
//             //   ),
//             // );
//           }
//         }
//       }
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  //local
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // var androidInitilize = const AndroidInitializationSettings('app_icon');
  var androidInitilize = const AndroidInitializationSettings('app_icon');
  var iOSinitilize = const IOSInitializationSettings();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  //fcm
  final firebaseMessaging = FirebaseMessaging.instance;
  late final SharedPreferences? sharedPreferences;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    initializeSettings();
    log("adasf");
    // await firebaseMessaging.subscribeToTopic("chembra_all");
    // if (ifuser) {
    //   isWholesale
    //       ? await firebaseMessaging.subscribeToTopic("chembra_wholesale")
    //       : await firebaseMessaging.subscribeToTopic("chembra_retail");
    // }
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(message.toString(), name: "message");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        Map notifData = message.data;
        log(notifData.toString(), name: "notif");
        String payload = jsonEncode(notifData);
        showLocalNotif(
          notification.hashCode,
          notification.title ?? "Unknown title",
          notification.body ?? "Unknown description",
          payload,
        );
      }
    });
  }

  //navigate
  void _handleMessage(RemoteMessage message) async {
    log(message.data.toString(), name: "handle message");
    if (message.data['type'] == 'Order') {
      // AppResources.showLoading();
      String orderId = message.data["click_id"];
      try {
        // Map body = {'order_id': orderId};
        // http.Response response =
        //     await http.post(Uri.parse(urlGetOrderDetails), body: body);
        // var result = await jsonDecode(response.body);
        // AppResources.navKey.currentState?.pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => SingleOrderView(
        //       orderItem: result["order"],
        //     ),
        //   ),
        // );
      } catch (e) {
        log('Error $e');
        // AppResources.navKey.currentState?.pop();
      }
    }
    if (message.data['type'] == 'Offer') {
      // productvid = message.data["click_id"];
      // AppResources.navKey.currentState?.push(
      //   MaterialPageRoute(
      //     builder: (context) => const SingleProductView(),
      //   ),
      // );
    }
  }

  showLocalNotif(int id, String title, String description, String payload) {
    var androidDetails = const AndroidNotificationDetails(
        "high_importance_channel", "High Importance Channel",
        importance: Importance.max);
    var iSODetails = const IOSNotificationDetails(
      presentAlert: true, // Required to display a heads up notification
      presentBadge: true,
      presentSound: true,
    );
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iSODetails);
    flutterLocalNotificationsPlugin
        .show(id, title, description, notificationDetails, payload: payload);
  }

  initializeSettings() async {
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin.initialize(
      initilizationsSettings,
      onSelectNotification: onSelectNotification,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      log('notification_payload: $payload', name: "onSelectNotification");
      Map data = jsonDecode(payload);
      if (data.isNotEmpty) {
        String clickId = data["click_id"];
        String type = data["type"];
        if (clickId.isNotEmpty && clickId != "0") {
          if (type == "Order") {
            try {
              // Map body = {'order_id': clickId};
              // http.Response response =
              //     await http.post(Uri.parse(urlGetOrderDetails), body: body);
              // var result = await jsonDecode(response.body);
              // AppResources.navKey.currentState?.pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => SingleOrderView(
              //       orderItem: result["order"],
              //     ),
              //   ),
              // );
            } catch (e) {
              log('Error $e');
            }
          }

          if (type == "Offer") {
            // productvid = clickId;
            // AppResources.navKey.currentState?.push(
            //   MaterialPageRoute(
            //     builder: (_) => const SingleProductView(),
            //   ),
            // );
          }
        }
      }
    }
  }

  ////////////////////////////////////////
  ///////////////// token ////////////////
  ////////////////////////////////////////

//   saveFCMToken() async {
//     try {
//       sharedPreferences = await SharedPreferences.getInstance();
//       if (ifuser) {
//         String savedFCM = sharedPreferences?.getString('fcm_token') ?? "";
//         if (savedFCM.isEmpty) {
//           firebaseMessaging.getToken().then((value) {
//             if (value != null) saveTokenServer(value);
//             log('Token: $value');
//           });
//         }
//       }
//     } catch (e) {
//       log('$e');
//     }
//   }

//   saveTokenServer(String token) async {
//     Map params = {'user_id': appuserid, 'token': token};
//     var response = await http.post(Uri.parse(urlSaveUserToken), body: params);
//     log("FCM Saved Server : ${response.body}");
//     if (response.statusCode == 200) {
//       if (response.body == "true") {
//         saveTokenLocally(token);
//       }
//     }
//   }

//   saveTokenLocally(String token) async {
//     sharedPreferences ??= await SharedPreferences.getInstance();
//     sharedPreferences?.setString('fcm_token', token);
//     log("FCM Saved Locally : $token");
//   }
}
