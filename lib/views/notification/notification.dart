
import 'package:etracker_client/controller/notificationcontroller.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
       
      ),
      body: FutureBuilder(
        future: context.read<NotificationController>().fetchNotifications(),
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
            } else if (snapshot.data == "ok") {
              return Consumer<NotificationController>(
                builder: (context, value, child) => body(context, value),
              );
            } else {
              return Center(
                child: Text(snapshot.data.toString()),
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

  Widget body(context, NotificationController cntr) {
    return cntr.notifications.isEmpty
        ? const Center(
            child: Text("Notifications is empty"),
          )
        : ListView.builder(
            itemCount: cntr.notifications.length,
            itemBuilder: (context, index) {
              var data = cntr.notifications[index];
              return Card(
                elevation: 2,
                surfaceTintColor: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  // height: 100,
                  width: sW(context),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Date : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          spaceWidth(4),
                          Text(
                            data.date.split(" ")[0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Title :",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          spaceWidth(4),
                          Text(
                            data.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      spaceHeight(2),
                      const Text(
                        "🔔 Message",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      spaceHeight(2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          data.message,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      spaceHeight(10),
                   
                    ],
                  ),
                ),
              );
            },
          );
  }

 

}
