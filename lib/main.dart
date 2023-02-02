import 'package:etracker_client/controller/authcontrollers.dart';
import 'package:etracker_client/controller/expenseController.dart';
import 'package:etracker_client/controller/homecontrollers.dart';
import 'package:etracker_client/controller/leavecontroller.dart';
import 'package:etracker_client/controller/notificationcontroller.dart';
import 'package:etracker_client/controller/profilecontroller.dart';
import 'package:etracker_client/controller/taskcontroller.dart';
import 'package:etracker_client/firebase_options.dart';
import 'package:etracker_client/splash/splash_screen.dart';
import 'package:etracker_client/utils/notification.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.data}");

// }

// getOnClickdata(){
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print("Handling a background message2: ${message.data}");
//   });
// }

//  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//         print("onMessageOpenedApp: $message");

//           if (message.data["navigation"] == "/your_route") {
//             int _yourId = int.tryParse(message.data["id"]) ?? 0;
//             Navigator.push(
//                     navigatorKey.currentState.context,
//                     MaterialPageRoute(
//                         builder: (context) => YourScreen(
//                               yourId:_yourId,
//                             )));
//         });
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => TaskController()),
        ChangeNotifierProvider(create: (context) => LeaveController()),
        ChangeNotifierProvider(create: (context) => NotificationController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => ExpenseController()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}
