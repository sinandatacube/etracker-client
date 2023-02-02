import 'package:flutter/material.dart';

sW(context) => MediaQuery.of(context).size.width;
sH(context) => MediaQuery.of(context).size.height;
spaceHeight(h) => SizedBox(
      height: h.toDouble(),
    );
spaceWidth(w) => SizedBox(
      width: w.toDouble(),
    );


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

 showLoading(String title,context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        });
  }

