class AllNotifications {
  final List<NotificationModel> notifications;

  AllNotifications({required this.notifications});

  factory AllNotifications.fromJson(Map<String, dynamic> json) =>
      AllNotifications(
        notifications: List<NotificationModel>.from(
          (json['items'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList(),
        ),
      );
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;

  NotificationModel(
      {required this.id,
      required this.title,
      required this.message,
      required this.date});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: json['_id'],
          title: json['title'],
          message: json['description'],
          date: json['date']);
}
