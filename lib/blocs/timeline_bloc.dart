import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/post_bloc.dart';
import 'package:pollocksschool/models/models.dart';

class TimelineBloc extends PostBloc {
  CollectionReference timelineCollectionRef;

  UserModel currentUser;

  List<PostModel> allPosts;

  Stream<QuerySnapshot> get timelinePostsStream =>
      timelineCollectionRef
          .doc(currentUser.classIds[0])
          .collection('classPosts')
          .orderBy('timestamp', descending: true).snapshots();


  TimelineBloc({@required this.currentUser}) {
    timelineCollectionRef = FirebaseFirestore.instance.collection("timeline");
  }

  updatePost(PostModel post, bool isLiked) async {
    await timelineCollectionRef
        .doc(post.classId)
        .collection('classPosts')
        .doc(post.postId)
        .update({'likes.${currentUser.id}': !isLiked});
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}