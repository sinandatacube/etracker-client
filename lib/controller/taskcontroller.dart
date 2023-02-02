import 'dart:developer';

import 'package:etracker_client/models/taskmodel.dart';
import 'package:etracker_client/services/api/apiservices.dart';
import 'package:etracker_client/services/db/pref.dart';
import 'package:flutter/cupertino.dart';

class TaskController extends ChangeNotifier {
  List<Tasks> tasks = [];

  getTasks() async {
    tasks = [];
    var userInfo = await Pref().getUserInfo();
    log(userInfo.toString());
    var res = await ApiServices().getTasks(empcode: userInfo['id']);
    if (res != '!200' && res != "error" && res != "noNetwork") {
      log(res.toString(), name: "task controller");
      if (res['success'] == 1) {
        var result = AllTasks.fromJson(res);
        List<Tasks> k =
            result.tasks.where((element) => element.status == "0").toList();
        tasks = k;
        return result;
      } else {
        return res['message'];
      }
    } else {
      return res;
    }
  }

  updateTask({required id}) async {
    var res = await ApiServices().updateTask(id: id);
    if (res != '!200' && res != "error" && res != "noNetwork") {
      log(res.toString(), name: "task controller");
      if (res['success'] == 1) {
        tasks.removeWhere((element) => element.id == id);
        notifyListeners();
        return "Task successfully updated !!";
      } else {
        return res['message'];
      }
    } else {
      return "some error occured --$res";
    }
  }
}
