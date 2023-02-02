import 'dart:developer';

import 'package:etracker_client/controller/expenseController.dart';
import 'package:etracker_client/models/expensemodel.dart';
import 'package:etracker_client/services/api/apiservices.dart';
import 'package:etracker_client/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Expence extends StatefulWidget {
  const Expence({super.key});

  @override
  State<Expence> createState() => _ExpenceState();
}

class _ExpenceState extends State<Expence> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiServices().getExpence(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(
                color: Color.fromARGB(255, 201, 33, 243),
                radius: 10,
              ),
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
            log(snapshot.data.toString());
            var result = snapshot.data;
            AllExpenses data = AllExpenses.fromJson(result);
            return Scaffold(
                floatingActionButton: buildFloatingButton(context),
                appBar: AppBar(
                  title: const Text("Expense"),
                ),
                body: buildBody(data));
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(
                color: Color.fromARGB(255, 201, 33, 243),
                radius: 10,
              ),
            ),
          );
        }
      },
    );
  }

  FloatingActionButton buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _addExpensePopupField(context);
      },
      child: const Icon(Icons.add),
    );
  }

  Widget buildBody(AllExpenses data) {
    return data.expense.isEmpty
        ? const Center(
            child: Text(
              "No expenses found",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3.0),
                    shrinkWrap: true,
                    itemCount: data.expense.length,
                    itemBuilder: (context, index) {
                      var current = data.expense[index];
                      return Card(
                          child: ListTile(
                        title: Text("Date : " +
                            current.date.split(" ")[0] +
                            "\n" +
                            current.description),
                        trailing: Column(
                          children: [
                            Text("Rs " + current.amount),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 20,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: current.status == "1"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Text(
                                current.status == "1" ? "Received" : "Pending",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ));
                    })
              ],
            ),
          );
  }

  Future<void> _addExpensePopupField(BuildContext context) async {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
                const SizedBox(
                  height: 7,
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Amount"),
                ),
              ],
            ),
            actions: <Widget>[
              Consumer<ExpenseController>(builder: (context, value, child) {
                return ElevatedButton(
                  //  color: Colors.green,
                  //  textColor: Colors.white,
                  child: value.isloading
                      ? const CupertinoActivityIndicator(
                          color: Color.fromARGB(255, 33, 194, 243),
                          radius: 10,
                        )
                      : const Text('Add'),
                  onPressed: () async {
                    String description = descriptionController.text.trim();
                    String amount = amountController.text.trim();

                    var result = await context
                        .read<ExpenseController>()
                        .addExpense(description, amount);
                    log(result.toString());
                    if (result == "success") {
                      context.read<ExpenseController>().loadingState();
                      navigatorKey.currentState!.pop();
                      setState(() {});
                    }
                  },
                );
              }),
            ],
          );
        });
  }
}
