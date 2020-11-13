import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  Timestamp timestamp;
  String avatarurl;
  String userid;


  CommentModel(
      {this.username, this.comment, this.timestamp, this.avatarurl, this.userid});

  factory CommentModel.fromDocument(QueryDocumentSnapshot doc) {
    return CommentModel(
        username : doc['username'],
        comment : doc['comment'],
        timestamp : doc['timestamp'],
        avatarurl : doc['avatarUrl'],
        userid : doc['userId']
    );
  }
}