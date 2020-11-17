import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String username;
  final String comment;
  final Timestamp timestamp;
  final String avatarurl;
  final String userid;
  final String id;


  CommentModel(
      {this.username, this.comment, this.timestamp, this.avatarurl, this.userid, this.id});

  factory CommentModel.fromDocument(QueryDocumentSnapshot doc) {
    return CommentModel(
        id : doc['id'],
        username : doc['username'],
        comment : doc['comment'],
        timestamp : doc['timestamp'],
        avatarurl : doc['avatarUrl'],
        userid : doc['userId']
    );
  }
}