class AllExpenses {
  final List<Expense> expense;

  AllExpenses({required this.expense});

  factory AllExpenses.fromJson(Map<String, dynamic> json) => AllExpenses(
      expense: List<Expense>.from(
          (json['expense'] as List).map((e) => Expense.fromJson(e)).toList()));
}

class Expense {
  final String id;
  final String empcode;
  final String name;
  final String date;
  final String description;
  final String amount;
  final String status;

  Expense(
      {required this.id,
      required this.empcode,
      required this.name,
      required this.date,
      required this.description,
      required this.status,
      required this.amount});

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
      id: json["_id"],
      empcode: json["empcode"],
      name: json["name"],
      date: json["date"],
      description: json["description"],
      status: json["status"],
      amount: json["amount"]);
}
