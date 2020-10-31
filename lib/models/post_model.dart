import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;
  final DateTime timestamp;

  PostModel({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.timestamp,
  });

  factory PostModel.fromDocument(QueryDocumentSnapshot doc) {

    return PostModel(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
      timestamp:DateTime.fromMicrosecondsSinceEpoch(doc['timestamp'].microsecondsSinceEpoch),
    );
  }

  String get getPostTime{
    return "${timestamp.hour}:${timestamp.minute}";
  }

  String get getPostDateString {
    String day = timestamp.day.toString();
    String month = _getMonth(timestamp.month);
    return "$day $month";
  }

  _getMonth(int month){
    final months = ['January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'];

    return months[month - 1] ?? '';
  }

  int get getLikeCount {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }
}