import 'package:etracker_client/controller/homecontrollers.dart';
import 'package:etracker_client/controller/taskcontroller.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: FutureBuilder(
        future: context.read<TaskController>().getTasks(),
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
              return Consumer<TaskController>(
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

  Widget body(BuildContext context, TaskController cntr) {
    return cntr.tasks.isEmpty
        ? const Center(
            child: Text("No new task"),
          )
        : ListView.builder(
            itemCount: cntr.tasks.length,
            itemBuilder: (context, index) {
              var data = cntr.tasks[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 2)
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              data.startDate.split(" ")[0],
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "DeadLIne :",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              data.deadline.split(" ")[0],
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      ],
                    ),
                    spaceHeight(10),
                    Row(
                      children: [
                        spaceWidth(10),
                        const Text(
                          "Task",
                          style: TextStyle(
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    spaceHeight(5),
                    Row(
                      children: [
                        const Text("📌"),
                        spaceWidth(3),
                        Text(data.task)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  updateDialog(context, cntr, data.id),
                            );
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              fixedSize: const Size(50, 20),
                              foregroundColor: Colors.green),
                          child: const Text(
                            "UPDATE",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }

  Dialog updateDialog(context, TaskController cntr, id) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 0,
          child: Column(
            // direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              spaceHeight(16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  "Do you want to complete the task ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              spaceHeight(32),
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  btn(context, onPressed: () async {
                    navigatorKey.currentState!.pop();
                    showLoading("Updating in...", context);
                    var res = await cntr.updateTask(id: id);
                    Fluttertoast.showToast(msg: res);
                    navigatorKey.currentState!.pop();
                  }, text: "confirm", color: Colors.blue),
                  btn(context, onPressed: () {
                    navigatorKey.currentState!.pop();
                  }, text: "cancel", color: Colors.red),
                ],
              )
            ],
          ),
        ),
      );

  ElevatedButton btn(context,
      {required void Function()? onPressed,
      required String text,
      required Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
