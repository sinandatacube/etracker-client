import 'dart:developer';
import 'package:etracker_client/models/leavesmodel.dart';
import 'package:etracker_client/services/api/apiservices.dart';
import 'package:etracker_client/services/db/pref.dart';
import 'package:flutter/material.dart';

class LeaveController extends ChangeNotifier {
  String lType = 'Half Day';
  String lDate = '';
  DateTimeRange? selectedRange;
  DateTime? startDate;
  DateTime? endDate;

  bool loading = false;

  List<Leaves> leaves = [];

  setLoading(val) {
    loading = val;
    notifyListeners();
  }

  getDateRange(DateTimeRange date) {
    selectedRange = date;
    if (selectedRange != null) {
      startDate = selectedRange!.start;
      endDate = selectedRange!.end;
      lDate =
          "${startDate.toString().split(" ")[0]}-${endDate.toString().split(" ")[0]}";
    }
    notifyListeners();
  }

  setIType(val) {
    lType = val;
    notifyListeners();
  }

  clearDates() {
    lDate = "";
    selectedRange = null;
    // startDate = null;
    // endDate = null;
    notifyListeners();
  }

  getLeaves() async {
    leaves = [];
    var userinfo = await Pref().getUserInfo();
    var res = await ApiServices().getLeaves(empcode: userinfo['id']);
    if (res != '!200' && res != "error" && res != "noNetwork") {
      log(res.toString(), name: "task controller");
      if (res['success'] == 1) {
        var result = AllLeaves.fromJson(res);
        leaves = result.leaves;
        notifyListeners();
        // tasks.removeWhere((element) => element.id == id);
        // notifyListeners();
        return "Task successfully updated !!";
      } else {
        return res['message'];
      }
    } else {
      return "some error occured --$res";
    }
  }

  insertLeave({required reason}) async {
    log("sdfds");
    setLoading(true);

    var userInfo = await Pref().getUserInfo();

    if (lDate.isEmpty) {
      setLoading(false);

      return "select the leavedate";
    } else {
      var res = await ApiServices().insertLeave(
          empcode: userInfo['id'],
          date: DateTime.now().toString(),
          type: lType,
          name: userInfo['name'],
          reason: reason,
          leaveDate: lDate);

      if (res != '!200' && res != "error" && res != "noNetwork") {
        log(res.toString(), name: "task controller");
        if (res['success'] == 1) {
          log(res.toString());
          // tasks.removeWhere((element) => element.id == id);
          // notifyListeners();
          setLoading(false);

          return "ok";
        } else {
          setLoading(false);

          return res['message'];
        }
      } else {
        setLoading(false);

        return "some error occured --$res";
      }
    }
  }
}
