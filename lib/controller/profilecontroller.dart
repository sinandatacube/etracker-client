import 'package:etracker_client/services/db/pref.dart';
import 'package:flutter/cupertino.dart';

class ProfileController extends ChangeNotifier {
   Map userinfo = {};

  setUserInfo()async{
    userinfo = {};
    var k = await Pref().getUserInfo();
    userinfo = k; 
    notifyListeners();
  }
}