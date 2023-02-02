import 'dart:async';
import 'dart:developer';

import 'package:etracker_client/controller/authcontrollers.dart';
import 'package:etracker_client/services/db/pref.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:etracker_client/views/auth/login_screen.dart';
import 'package:etracker_client/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getImei();
    checkCreditonals();
    super.initState();
  }

  Future getImei()async{
     String? deviceId;
     try {
    bool  isImei = await Pref().isImei();
    if (!isImei) {
      log("no imei code");
       deviceId = await PlatformDeviceId.getDeviceId;
     await Pref().setImei(deviceId);
    } 
      log("has imei code");

     } catch (e) {
       Fluttertoast.showToast(msg: "some error occured $e");
     }
     
  }

  checkCreditonals()async{
   var result = await context.read<AuthController>().checkCredtional();
   if (result) {
     navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>const HomeScreen(),
      ));
   } else {
     navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
              height: 300,
            ),
          ),
          const CupertinoActivityIndicator(
            color: Color.fromARGB(255, 201, 33, 243),
            radius: 10,
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
