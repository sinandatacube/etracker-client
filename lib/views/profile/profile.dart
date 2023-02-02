
import 'package:etracker_client/services/db/pref.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Profile"),
      ),
      body: FutureBuilder(
        future: Pref().getUserInfo(),
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
              return  body(context, snapshot.data);
              
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

  Column body(BuildContext context,  value) {
    return Column(
      children: [
        spaceHeight(10),
         Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 3,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              // height: 400,
              width: sW(context) - 40,
              child: Column(
                children: [
                  spaceHeight(5),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                  ),
                  spaceHeight(5),
                  tile(txt: "EmpCode", content: value['id']),
                  tile(
                      txt: "EmpName", content:value['name']),
                  tile(txt: "Position", content: value['position'], isRole: true),
                  tile(txt: "Phone", content: value['number']),
                  tile(txt: "Age", content: value['age']),
                ],
              ),
            ),
          ),
        ],
      ),
      ],
    );
  }

   Padding tile({required txt, required content, isRole = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  "$txt :",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isRole
                            ?const Color.fromARGB(255, 10, 17, 75)
                            : Colors.grey),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}