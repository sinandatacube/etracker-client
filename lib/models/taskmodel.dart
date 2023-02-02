class AllTasks {
  final List<Tasks> tasks;

  AllTasks({required this.tasks});

  factory AllTasks.fromJson(Map<String, dynamic> json) => AllTasks(
        tasks: List<Tasks>.from(
          (json['tasks'] as List).map(
            (e) => Tasks.fromJson(e),
          ),
        ),
      );
}

class Tasks {
  final String id;
  final String empcode;
  final String startDate;
  final String deadline;
  final String task;
  final String status;

  Tasks(
      {required this.id,
      required this.empcode,
      required this.startDate,
      required this.deadline,
      required this.status,
      required this.task});

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
      id: json["_id"],
      empcode: json["empcode"],
      startDate: json["startdate"],
      deadline: json["deadline"],
      status: json['status'].toString(),
      task: json["task"]);
}
