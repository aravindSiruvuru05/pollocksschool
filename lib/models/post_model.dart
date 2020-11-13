import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String classId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;
  final Timestamp timestamp;
  final int commentsCount;
  final String ownerProfileImgUrl;

  PostModel({
    this.classId,
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.timestamp,
    this.commentsCount,
    this.ownerProfileImgUrl,
  });

  factory PostModel.fromDocument(QueryDocumentSnapshot doc) {
    return PostModel(
      postId: doc.id,
      ownerId: doc['ownerId'],
      classId: doc['classId'],
      username: doc['username'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
      timestamp: doc['timestamp'],
      commentsCount: doc['commentsCount'],
      ownerProfileImgUrl: doc['ownerProfileImgUrl'],
    );
  }

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      'postId' : postId,
      'ownerId' : ownerId,
      'classId' : classId,
      'username' : username,
      'description' : description,
      'mediaUrl' : mediaUrl,
      'likes' : likes,
      'timestamp' : timestamp,
      'commentsCount' : commentsCount,
      'ownerProfileImgUrl' : ownerProfileImgUrl,
    };
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