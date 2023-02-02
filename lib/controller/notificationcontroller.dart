import 'dart:developer';

import 'package:etracker_client/models/notificationmodel.dart';
import 'package:etracker_client/services/api/apiservices.dart';
import 'package:flutter/cupertino.dart';

class NotificationController extends ChangeNotifier {
  List<NotificationModel> notifications = [];

  bool isLoading = false;


  
  fetchNotifications() async {
    notifications = [];
    var res = await ApiServices().fetchNotification();

    if (res != '!200' && res != "error" && res != "noNetwork") {
      if (res["success"] == 1) {
        var result = AllNotifications.fromJson(res);
        notifications = result.notifications;
        notifyListeners();
        return "ok";
      } else {
        return res['message'];
      }
    } else {
      log(res);
      return res;
    }
  }

}