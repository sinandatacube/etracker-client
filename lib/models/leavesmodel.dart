class AllLeaves {
  final List<Leaves> leaves;

  AllLeaves({ required this.leaves});

  factory AllLeaves.fromJson(Map<String,dynamic>json)=>AllLeaves(
    leaves: List<Leaves>.from((json['requests'] as List).map((e) => Leaves.fromJson(e)).toList())
    );
}

class Leaves {
  final String id;
  final String status;
  final String date;
  final String reason;

  Leaves(
      {required this.id,
      required this.status,
      required this.date,
      required this.reason});

  factory Leaves.fromJson(Map<String, dynamic> json) =>
      Leaves(id: json["_id"],
       status: json["status"].toString(),
        date: json["leavedate"],
         reason: json["reason"]);
}
