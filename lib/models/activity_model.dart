
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollocksschool/enums/activity_type.dart';

class ActivityModel {
  final String caption;
  final String mediaUrl;
  final String postId;
  final Timestamp timestamp;
  final ActivityType type;
  final String userId;
  final String userProfileImg;
  final String username;

  static ActivityType getActivityType(String type) {
    switch(type){
      case 'LIKE': {
        return ActivityType.LIKE;
      }break;
      case 'COMMENT': {
        return ActivityType.COMMENT;
      }break;
      default: {
        return ActivityType.POST;
      }break;
    }
  }

  ActivityModel({this.caption, this.mediaUrl, this.postId, this.timestamp, this.type, this.userId, this.userProfileImg, this.username});

  factory ActivityModel.fromDocument(QueryDocumentSnapshot doc) {
    return ActivityModel(
        caption : doc['caption'],
        mediaUrl : doc['mediaUrl'],
        postId : doc['postId'],
        timestamp : doc['timestamp'],
        type : getActivityType(doc['type']),
        userId : doc['userId'],
        userProfileImg : doc['userProfileImg'],
        username : doc['username']
    );
  }
}