import 'dart:developer';

import 'package:etracker_client/controller/authcontrollers.dart';
import 'package:etracker_client/controller/homecontrollers.dart';
import 'package:etracker_client/services/api/apiservices.dart';
import 'package:etracker_client/splash/splash_screen.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:etracker_client/views/attendence/attendence.dart';
import 'package:etracker_client/views/expense/expense.dart';
import 'package:etracker_client/views/leave/leaves.dart';
import 'package:etracker_client/views/notification/notification.dart';
import 'package:etracker_client/views/profile/profile.dart';
import 'package:etracker_client/views/task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../utils/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = Location();
//// check gps status
  checkGps() async {
    bool servieStatus = await Geolocator.isLocationServiceEnabled();
    if (servieStatus) {
      log("gps enabled");
    } else {
      log("gps not enabled");
      await location.requestService();
    }
  }

  /// location permision

  locationPermissionCheck() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        location.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
        log("'Location permissions are permanently denied");
      } else {
        log("GPS Location service is granted");
      }
    } else {
      log("GPS Location permission granted.");
    }
  }

// check punch

  checkPunch() async {
    await context.read<HomeController>().checkPunchIn();
  }

  @override
  void initState() {
    NotificationServices().setupInteractedMessage();
    checkGps();
    locationPermissionCheck();
    checkPunch();
    ApiServices().saveFCMTokentoServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await exit(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: Image.asset("assets/images/logo.png"),
          title: const Text(
            "ETracker Client",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          backgroundColor: Colors.white,
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // PopupMenuItem 1
                PopupMenuItem(
                  value: 1,
                  onTap: () =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => Profile(),
                  )),
                  // row with 2 children
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.purple,
                      ),
                      spaceWidth(10),
                      const Text("Profile")
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  onTap: () async {
                    var res = await context.read<AuthController>().userLogout();
                    res == 1
                        ? navigatorKey.currentState!.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ),
                            (route) => false)
                        : Fluttertoast.showToast(msg: "some error occurred !");
                  },
                  // row with 2 children
                  child: Row(
                    children: [
                      const Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.red,
                      ),
                      spaceWidth(10),
                      const Text("Logout")
                    ],
                  ),
                ),
              ],
              offset: const Offset(0, 10),
              color: Colors.white,
              elevation: 2,
              // on selected we show the dialog box
              onSelected: (value) {
                // // if value 1 show dialog
                // if (value == 1) {
                //   _showDialog(context);
                //   // if value 2 show dialog
                // } else if (value == 2) {
                //   _showDialog(context);
                // }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
          child: Consumer<HomeController>(
              builder: (context, value, child) => Stack(
                    children: [
                      GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: value.content.length,
                        padding: const EdgeInsets.only(bottom: 5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // childAspectRatio: 3 / 2,
                          childAspectRatio: 1, //1/2
                          mainAxisExtent: 180,
                          crossAxisSpacing: 10, // 5,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          var current = value.content[index];
                          //var id = content[index]["id"];//
                          return _buildTile(
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Material(
                                      color: index == 0
                                          ? const Color.fromARGB(
                                              255, 244, 54, 54)
                                          : index == 1
                                              ? Colors.grey
                                              : index == 2
                                                  ? const Color.fromARGB(
                                                      255, 91, 231, 95)
                                                  : index == 3
                                                      ? Colors.blue
                                                      : index == 5
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 201, 33, 243)
                                                          : Colors.amber,
                                      shape: const CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(current['ic'],
                                            color: Colors.white, size: 20.0),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 16.0)),
                                    Text(current['txt'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0)),
                                    Text(
                                      current['subtxt'],
                                      style: const TextStyle(
                                          color: Colors.black45),
                                    ),
                                  ]),
                            ),
                            onTap: () async {
                              // log(index.toString());
                              index == 1
                                  ? {
                                      showDialog(
                                        context: context,
                                        builder: (context) => value
                                                .punchId.isNotEmpty
                                            ? punchOutDialog(context,
                                                context.read<HomeController>())
                                            : punchInDialog(context,
                                                context.read<HomeController>()),
                                      )
                                    }
                                  : index == 0
                                      ? navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                          builder: (context) => Task(),
                                        ))
                                      : index == 2
                                          ? navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                              builder: (context) => Leaves(),
                                            ))
                                          : index == 3
                                              ? navigatorKey.currentState!
                                                  .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      Notifications(),
                                                ))
                                              : index == 5
                                                  ? navigatorKey.currentState!
                                                      .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Expence(),
                                                    ))
                                                  : index == 4
                                                      ? navigatorKey
                                                          .currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                          builder: (context) =>
                                                              Attendence(),
                                                        ))
                                                      : null;
                              // index == 0
                              //     ? navigatorKey.currentState!.push(MaterialPageRoute(
                              //         builder: (context) => const AllEmployees(),
                              //       ))
                              //     //onPunchClick()
                              //     : index == 1
                              //         ? navigatorKey.currentState!
                              //             .push(MaterialPageRoute(
                              //             builder: (context) => const Tasks(),
                              //           )) // Navigator.of(context)
                              //         //.pushNamed(ConfigGlobal.leavesTag)
                              //         : index == 2
                              //             ? navigatorKey.currentState!
                              //                 .push(MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     const LeavesScreen(),
                              //               ))
                              //             : index == 3
                              //                 ? navigatorKey.currentState!
                              //                     .push(MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         const Notifications(),
                              //                   ))
                              //                 : print("object");
                            },
                          );
                        },
                      ),
                    ],
                  )),
        ),
      ),
    );
  }

  Dialog punchInDialog(context, HomeController cntr) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 0,
          child: Column(
            // direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              spaceHeight(16),
              const Text(
                "Do you want to Punch in ?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              spaceHeight(32),
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  btn(context, onPressed: () async {
                    navigatorKey.currentState!.pop();
                    showLoading("Punching in...", context);
                    var res = await cntr.punchIn();
                    navigatorKey.currentState!.pop();
                  }, text: "confirm", color: Colors.blue),
                  btn(context, onPressed: () {
                    navigatorKey.currentState!.pop();
                  }, text: "cancel", color: Colors.red),
                ],
              )
            ],
          ),
        ),
      );

  Dialog punchOutDialog(context, HomeController cntr) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              spaceHeight(16),
              const Text(
                "Do you want to Punch out ?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              spaceHeight(32),
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  btn(context, onPressed: () async {
                    navigatorKey.currentState!.pop();
                    showLoading("Punching Out...", context);
                    var res = await cntr.punchOut();
                    navigatorKey.currentState!.pop();
                  }, text: "confirm", color: Colors.blue),
                  btn(context, onPressed: () {
                    navigatorKey.currentState!.pop();
                  }, text: "cancel", color: Colors.red),
                ],
              )
            ],
          ),
        ),
      );

  ElevatedButton btn(context,
      {required void Function()? onPressed,
      required String text,
      required Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: const Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  Future<dynamic> exit(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Row(
          children: [
            const Text(
              "Exit",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w600, fontSize: 20),
            ),
            spaceWidth(2),
            const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          ],
        ),
        content: const Text(
          "Are you sure ,you want to leave from ETracker ?",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(40, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                backgroundColor: const Color.fromARGB(255, 201, 33, 243),
                foregroundColor: Colors.white),
            child: const Text(
              "No",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.red),
              ))
        ],
      ),
    );
  }
}
