import 'dart:developer';
import 'package:etracker_client/controller/leavecontroller.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:etracker_client/views/leave/leaves.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeaveRequest extends StatelessWidget {
  LeaveRequest({super.key});
  final leaveReasonCntr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
          builder: (context) => const Leaves(),
        ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Leave Request"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                spaceHeight(20),
                txt("Leave Type"),
                spaceHeight(5),
                Consumer<LeaveController>(
                  builder: (context, value, child) => Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: DropdownButton<String>(
                        value: value.lType,
                        hint: const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text("Selet an option")),
                        underline: Container(
                          color: Colors.white,
                          height: 1,
                        ),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          value.setIType(newValue!);
                          // setDateRangeText();
                        },
                        items: <String>['Half Day', 'Full Day']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                spaceHeight(20),
                txt("Pick Date"),
                spaceHeight(5),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Consumer<LeaveController>(
                            builder: (context, value, child) => InkWell(
                              onTap: () {
                                pickDateRange(context);
                              },
                              child: Text(
                                value.selectedRange == null
                                    ? "Select date"
                                    : "${DateFormat("dd/MM/yyyy").format(value.startDate!)} - ${DateFormat("dd/MM/yyyy").format(value.endDate!)}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 51, 45, 53)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                spaceHeight(20),
                txt("Reason"),
                spaceHeight(5),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5, //Normal textInputField will be displayed
                  maxLines: 5,
                  controller: leaveReasonCntr,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Write here...',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ), // when user presses enter it will adapt to it
                ),
                spaceHeight(20),
             Consumer<LeaveController>(builder: (context, value, child) =>    ElevatedButton(
                  onPressed:value.loading? (){} : () async {
                    if (leaveReasonCntr.text.isNotEmpty) {
                      log("is not empty");
                      var k = await value.insertLeave(
                            reason: leaveReasonCntr.text.trim(),
                          );
                      if (k == "ok") {
                        leaveReasonCntr.text = '';
                        // ignore: use_build_context_synchronously
                        value.clearDates();
                        Fluttertoast.showToast(
                            msg: "Leave request successfullty submited !!");
                      } else {
                        Fluttertoast.showToast(msg: k);
                      }

                      log(k.toString(), name: "k");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 201, 33, 243),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fixedSize: Size(sW(context) / 2, 20),
                  ),
                  child:value.loading? const  CupertinoActivityIndicator(
                color: Colors.white,
                radius: 10,
              ): const Text("Submit"),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickDateRange(BuildContext context) async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,

      firstDate: DateTime.now(), // the earliest allowable
      lastDate:
          DateTime.now().add(const Duration(days: 30)), // the latest allowable
      currentDate: DateTime.now(),
      saveText: 'Done',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 201, 33, 243),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 201, 33, 243),
            ).copyWith(secondary: const Color(0xFF8CE7F1)),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      // ignore: use_build_context_synchronously
      context.read<LeaveController>().getDateRange(result);
    }
  }

  txt(val) => Row(children: [
        Text(
          val,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        )
      ]);
}
