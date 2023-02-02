import 'dart:developer';

import 'package:etracker_client/services/api/apiservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Attendence extends StatelessWidget {
  const Attendence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Attendence"),
      ),
      body: FutureBuilder(
        future: ApiServices().getAttendences(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Color.fromARGB(255, 201, 33, 243),
                radius: 10,
              ),
            );
          }
// (snapshot.connectionState == ConnectionState.done)
          else {
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
                child: Text("no network"),
              );
            } else {
              log(snapshot.data["items"].toString());
              var data = snapshot.data["items"];
              return data.isEmpty
                  ? const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(2.0),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var current = data[index];

                        if (current["checkinstatus"] == 0) {
                          List inData = current["indate"].split(" ");
                          List outData = current["outdate"].split(" ");

                          List inCompleteTime = inData[1].split(".");
                          List outCompleteTime = outData[1].split(".");

                          return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text("Date : ${inData[0]}"),
                                  subtitle: Text(
                                      "in : ${inCompleteTime[0]}\nout : ${outCompleteTime[0]}"),
                                  trailing: Text(
                                      "Worked hour : ${current["workhours"]}\nOver Time : ${current["overtime"]}"),
                                ),
                              ));
                        } else {
                          return const SizedBox();
                        }
                      });
            }
          }
        },
      ),
    );
  }
}
