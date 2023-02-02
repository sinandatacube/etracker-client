import 'package:etracker_client/controller/leavecontroller.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:etracker_client/views/leave/leave_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Leaves extends StatelessWidget {
  const Leaves({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaves"),
        actions: [
          IconButton(
              onPressed: () {
                navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                  builder: (context) => LeaveRequest(),
                ));
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 201, 33, 243),
              ))
        ],
      ),
      body: FutureBuilder(
        future: context.read<LeaveController>().getLeaves(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Color.fromARGB(255, 201, 33, 243),
                radius: 10,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == "!200") {
              return const Center(
                child: Text("!200"),
              );
            } else if (snapshot.data == "error") {
              return const Center(
                child: Text("error"),
              );
            } else if (snapshot.data == "noNetwork") {
              return const Center(
                child: Text("nonetwork"),
              );
            } else {
              return Consumer<LeaveController>(
                builder: (context, value, child) => body(context, value),
              );
            }
          } else {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Color.fromARGB(255, 201, 33, 243),
                radius: 10,
              ),
            );
          }
        },
      ),
    );
  }

  Widget body(context, LeaveController cntr) {
    return 
    
    cntr.leaves.isEmpty? const Center(child: Text("No leave request found"),):
     ListView.builder(
        itemCount: cntr.leaves.length,
        itemBuilder: (context, index) {
          var data = cntr.leaves[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(toBeginningOfSentenceCase(data.date)!),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      loadLeaveStat(data.status),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Text(
                            toBeginningOfSentenceCase(data.reason)!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blue),
                          ))),
                      // loadLeaveStat(offices[index]['type']),
                    ],
                  ),
                  spaceHeight(10)
                ],
              ),
            ),
          );
        });
  }

  Widget loadLeaveStat(String text) {
    Color bgColr = Colors.yellow;
    Color textColr = Colors.yellow;
    String statLeave = "Waiting";
    if (text.toLowerCase() == '0') {
      bgColr = const Color.fromARGB(255, 201, 33, 243);
      textColr = Colors.white;
      statLeave = "Waiting";
    } else if (text.toLowerCase() == '1') {
      bgColr = Colors.green;
      textColr = Colors.white;
      statLeave = "Approved";
    } else {
      bgColr = Colors.red;
      textColr = Colors.white;
      statLeave = "Rejected";
    }
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(3), color: bgColr),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          toBeginningOfSentenceCase(statLeave)!,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColr),
        ),
      ),
    );
  }
}
