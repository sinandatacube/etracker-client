import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:etracker_client/config/config.dart';
import 'package:etracker_client/services/db/pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  checkLogin({required id, required psw, required imei}) async {
    try {
      Map body = {"password": psw, "empcode": id, "imei": imei};
      var res = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      //  log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  /// punchin

  punchIn({required empcode, required name, required lat, required lon}) async {
    try {
      Map body = {
        "empcode": empcode,
        "name": name,
        "date": DateTime.now().toString(),
        "inlocation": "$lat,$lon"
      };
      var res = await http.post(
        Uri.parse(checkInUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  punchOut({required id, required lat, required lon}) async {
    try {
      log(id, name: "id");
      Map body = {
        "outlocation": "$lat,$lon",
        "date": DateTime.now().toString(),
      };
      log(body.toString());
      var res = await http.put(
        Uri.parse(punchOutUrl + id),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      log(res.toString(), name: "nne");
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString(), name: "res");
      return "error";
    }
  }

  getTasks({required empcode}) async {
    try {
      Map body = {"empcode": empcode};
      var res = await http.post(
        Uri.parse(getTaskUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  updateTask({required id}) async {
    try {
      Map body = {"taskid": id};
      var res = await http.post(
        Uri.parse(updateTaskUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  getLeaves({required empcode}) async {
    try {
      Map body = {"empcode": empcode};
      var res = await http.post(
        Uri.parse(getLeavesUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  insertLeave(
      {required empcode,
      required date,
      required type,
      required name,
      required reason,
      required leaveDate}) async {
    try {
      Map body = {
        "empcode": empcode,
        "reason": reason,
        "leavedate": leaveDate,
        "date": date,
        "type": type,
        "name": name
      };
      var res = await http.post(
        Uri.parse(insertLeaveUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  fetchNotification() async {
    try {
      var res = await http.get(
        Uri.parse(getNotificationUrl),
        headers: {"Content-Type": "application/json"},
      );

      log(res.body.toString());

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        log(res.body, name: 'body');
        return body;
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      return "error";
    }
  }

  getExpence() async {
    try {
      var userInfo = await Pref().getUserInfo();
      Map body = {
        "empcode": userInfo['id'],
      };
      var res = await http.post(
        Uri.parse(getExpenseUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  getAttendences() async {
    try {
      var userInfo = await Pref().getUserInfo();
      Map body = {"empcode": userInfo['id']};
      var res = await http.post(
        Uri.parse(getAttendenceUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  addExpence(String date, String description, String amount) async {
    try {
      var userInfo = await Pref().getUserInfo();
      Map body = {
        "empcode": userInfo['id'],
        "name": userInfo['name'],
        "date": date,
        "description": description,
        "amount": amount
      };
      var res = await http.post(
        Uri.parse(expenseUrl),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return "!200";
      }
    } on SocketException {
      return "noNetwork";
    } catch (e) {
      log(e.toString());
      return "error";
    }
  }

  Future saveFCMTokentoServer() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userdata = await Pref().getUserInfo();
      log(userdata.toString());
      String empCode = userdata["id"];
      if (empCode.isNotEmpty && empCode != '0') {
        String savedFCM = sharedPreferences.getString('fcm_token') ?? '';
        log(savedFCM.toString(), name: "saved fcm");
        if (savedFCM.isEmpty) {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String fcmToken = await messaging.getToken() ?? '';
          if (fcmToken.isNotEmpty) {
            Map params = {'empcode': empCode, 'fcm': fcmToken};
            log(params.toString(), name: "params");

            var response = await http.post(
              Uri.parse(
                  "https://employee-management-usz2.onrender.com/empl/update_fcm"),
              body: jsonEncode(params),
              headers: {"Content-Type": "application/json", 'Charset': 'utf-8'},
            );

            log(response.statusCode.toString(), name: "result");

            if (response.statusCode == 200) {
              var result = jsonDecode(response.body);
              log("result.toString()");
              log(result.toString());
              if (result["success"] == 1) {
                saveFCMToken(fcmToken);
              }
            }

            // if (response.statusCode == 200) {
            //   var result = await jsonDecode(response.body);
            //   log("result.toString()");
            //   log(result.toString());
            //   log(fcmToken);
            //   if (result["success"] == 1) {
            //     print("local");
            //     saveFCMToken(fcmToken);
            //   }
            // print('fcm res server ' + result.toString());
            // }
          }
        }
      }
    } catch (e) {
      log(e.toString());
      debugPrint(e.toString());
    }
  }

//fcm locally
  void saveFCMToken(var fcmToken) async {
    debugPrint('FCM Saved');
    var sharedPreferences = await SharedPreferences.getInstance();
    String savedFCM = sharedPreferences.getString('fcm_token') ?? '';
    if (savedFCM.isEmpty) {
      sharedPreferences.setString('fcm_token', fcmToken);
    }
  }
}
