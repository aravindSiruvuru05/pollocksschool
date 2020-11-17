class PushNotificationModel {
  final String postId;
  final String type;
  final String title;

  PushNotificationModel({this.postId, this.type, this.title});

  PushNotificationModel.fromMap(Map<String, dynamic> map)
      : this.postId = map['postId'],
        this.type = map['type'],
        this.title = map['notification']['title'];
}
