import 'dart:developer';

import 'package:etracker_client/services/api/apiservices.dart';
import 'package:flutter/cupertino.dart';

class ExpenseController extends ChangeNotifier {
  bool isloading = false;
  loadingState() {
    isloading = !isloading;
    notifyListeners();
  }

  addExpense(
    String description,
    String amount,
  ) async {
    loadingState();
    String date = DateTime.now().toString();
    var result = await ApiServices().addExpence(date, description, amount);
    log(result.toString());
    return result["message"];
  }
}
