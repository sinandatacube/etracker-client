import 'dart:developer';

import 'package:etracker_client/services/api/apiservices.dart';
import 'package:etracker_client/services/db/pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as l;

class HomeController extends ChangeNotifier {
  var punchId = "";
  bool punchLoading = false;

  List<Map> content = [
    {
      "txt": 'Task',
      "subtxt": " View tasks assigned",
      "ic": Icons.task,
    },
    {
      "txt": 'Punch In',
      "subtxt": "Ready to work",
      "ic": Icons.fingerprint,
    },
    {
      "txt": 'Leaves',
      "subtxt": "Apply leave requests",
      "ic": Icons.leave_bags_at_home,
    },
    {
      "txt": 'Notification',
      "subtxt": "View company notifications",
      "ic": Icons.notification_add,
    },
    {
      "txt": 'Attendence',
      "subtxt": "View  attendence",
      "ic": Icons.work_history,
    },
    {
      "txt": 'Expense',
      "subtxt": "Add Expense",
      "ic": Icons.money,
    },
  ];

  /// punch in

  setPunchLoad(val) {
    punchLoading = val;
    notifyListeners();
  }

  punchIn() async {
    setPunchLoad(true);
    bool isEnabled = await checkGps();
    if (!isEnabled) {
      Fluttertoast.showToast(msg: "please enable the location !!");
      setPunchLoad(false);
      return;
    }
    await locationPermissionCheck();
    var userInfo = await Pref().getUserInfo();
    //// api services
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var res = await ApiServices().punchIn(
        empcode: userInfo['id'],
        name: userInfo['name'],
        lat: position.latitude.toString(),
        lon: position.longitude.toString());
    log(res.toString(), name: "home controller");
    if (res != '!200' && res != "error" && res != "noNetwork") {
      if (res['success'] == 1) {
        await Pref().setPunchInId(id: res['id']);
        punchId = res['id'];
        content[1] = {
          "txt": 'Punch Out',
          "subtxt": "leave the work",
          "clr": Colors.green,
          "ic": Icons.logout,
        };
        setPunchLoad(false);
      } else {
        Fluttertoast.showToast(msg: res['message']);
        setPunchLoad(false);
      }
    } else {
      Fluttertoast.showToast(msg: "some error occured--$res !!");
      setPunchLoad(false);
    }
    log(punchId);
    notifyListeners();
  }

  checkPunchIn() async {
    var id = await Pref().getPunchId();
    log(id.toString(), name: "check punch");
    if (id != null) {
      punchId = id;
      content[1] = {
        "txt": 'Punch Out',
        "subtxt": "leave the work",
        "clr": Colors.green,
        "ic": Icons.logout,
      };
    }
    notifyListeners();
  }

  checkGps() async {
    // Location location = Location();

    bool servieStatus = await Geolocator.isLocationServiceEnabled();
    if (servieStatus) {
      // log("gps enabled");
      return true;
    } else {
      log("gps not enabled");
      return false;
      // await location.requestService();
    }
  }

  locationPermissionCheck() async {
    l.Location location = l.Location();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        location.requestPermission();
        return;
      } else if (permission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
        log("'Location permissions are permanently denied");
        return;
      } else {
        log("GPS Location service is granted");
      }
    } else {
      log("GPS Location permission granted.");
    }
  }

  /// *************  PUNCH OUT **************/

  punchOut() async {
    var id = await Pref().getPunchId() ?? "noooo";
    log(id, name: "idsss");
    locationPermissionCheck();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var res = await ApiServices().punchOut(
        id: id,
        lat: position.latitude.toString(),
        lon: position.longitude.toString());
    log(res.toString(), name: "punch out");
    if (res != '!200' && res != "error" && res != "noNetwork") {
      if (res['success'] == 1) {
        content[1] = {
          "txt": 'Punch In',
          "subtxt": "Ready to work",
          "ic": Icons.fingerprint,
        };
        Pref().removePunchInId();
        punchId = '';
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: res['message']);
      }
    } else {
      Fluttertoast.showToast(msg: "some error occured--$res !!");
    }
  }
}
