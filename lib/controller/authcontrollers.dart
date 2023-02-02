import 'dart:developer';

import 'package:etracker_client/models/loginmodel.dart';
import 'package:etracker_client/services/api/apiservices.dart';
import 'package:etracker_client/services/db/pref.dart';
import 'package:flutter/cupertino.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  String deviceId = "";

  setImei(val) {
    deviceId = val;
    // notifyListeners();
  }

  checkLogin({
    required empcode,
    required psw,
  }) async {
    setloading(true);
    var imeiCode = await Pref().getImei();
    log(imeiCode.toString(),name: 'auth controller');
    var res =
        await ApiServices().checkLogin(id: empcode, psw: psw, imei: imeiCode);
    log(res.toString(), name: "authcontroller");
    if (res != '!200' && res != "error" && res != "noNetwork") {
      if (res['success'] == 1) {
        AllLoginModel result = AllLoginModel.fromJson(res);
        Pref().setUserInfo(
            psw: psw,
            empcode: result.items.empcode,
            name: result.items.username + result.items.lastname,
            number: result.items.number,
            age: result.items.age,
            position: result.items.position);
        setloading(false);

        return "ok";
      } else {
        setloading(false);

        return res['message'];
      }
    } else {
      setloading(false);
      return res;
    }
  }

  setloading(val) {
    isLoading = val;
    notifyListeners();
  }

  checkCredtional() async {
    var res = await Pref().getUserCreditional();
    log(res.toString(),name: "user cred");
    var result =
        await checkLogin(empcode: res['id'], psw: res['psw']);
    if (result == "ok") {
      return true;
    } else {
      return false;
    }
  }

  userLogout() async {
    var res = await Pref().logout();
    return res;
  }
}
