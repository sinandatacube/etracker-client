import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  setUserInfo(
      {required empcode,
      required name,
      required number,
      required age,
      required psw,
      required position}) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString('empcode', empcode);
    await pref.setString('username', name);
    await pref.setString('number', number);
    await pref.setString('position', position);
    await pref.setString('age', age);
    await pref.setString('psw', psw);
  }

  getUserInfo() async {
    var pref = await SharedPreferences.getInstance();
    var id = pref.getString('empcode');
    var name = pref.getString('username');
    var number = pref.getString('number');
    var age = pref.getString('age');
    var position = pref.getString('position');
    return {
      "id": id,
      "name": name,
      "number": number,
      "age": age,
      "position": position
    };
  }

  getUserCreditional() async {
    var pref = await SharedPreferences.getInstance();
    var id = pref.getString('empcode');
    var psw = pref.getString('psw');
    return {"id": id, "psw": psw};
  }

  logout() async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove("id");
    await pref.remove("psw");
    await pref.remove("empcode");
    await pref.remove("age");
    await pref.remove("number");
    await pref.remove("position");
    await pref.remove("username");
    await pref.remove("punchId");

    return 1;
  }

  setPunchInId({required id}) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setString("punchId", id);
    String? asd = pref.getString("punchId");
    log(asd ?? "null", name: "shared");
  }

  getPunchId() async {
    var pref = await SharedPreferences.getInstance();
    String? asd = pref.getString("punchId");
    log(asd ?? "null", name: "shared");
    return pref.getString("punchId");
  }

  removePunchInId() async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove("punchId");
  }

  setImei(val) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString("imei", val);
  }

  getImei() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString("imei");
  }

  isImei() async {
    var pref = await SharedPreferences.getInstance();
    return pref.containsKey("imei");
  }
}
