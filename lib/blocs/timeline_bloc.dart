

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pollocksschool/blocs/post_bloc.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/models/post_model.dart';

class TimelineBloc extends PostBloc{
  CollectionReference timelineCollectionRef;
  CollectionReference _postCollectionRef;

  UserModel currentUser;

  List<PostModel> allPosts;

//  final _timelinepostsController =
//  StreamController<List<PostModel>>.broadcast();
  Stream<QuerySnapshot> get timelinePostsStream => timelineCollectionRef
      .doc(currentUser.classIds[0])
      .collection('classPosts')
      .orderBy('timestamp', descending: true).snapshots();
//  Function get _timelinePostsSink => _timelinepostsController.sink.add;


  TimelineBloc({@required this.currentUser}):super(currentUser: currentUser){
    timelineCollectionRef = FirebaseFirestore.instance.collection("timeline");
  }

  updatePost(PostModel post, bool isLiked) async{
    print(post.postId);
    print("===");
    print(isLiked);
    await timelineCollectionRef
        .doc(post.classId)
        .collection('classPosts')
        .doc(post.postId)
        .update({'likes.${currentUser.id}': !isLiked});
//    getPosts();
  }


//  getPosts() async{
//    QuerySnapshot snapshot = await _timelineCollectionRef
//        .doc(currentUser.classIds[0])
//        .collection('classPosts')
//        .orderBy('timestamp', descending: true)
//        .get();
//    final posts = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
//
//    posts == null ? allPosts = [] : allPosts = posts;
//    _timelinePostsSink(allPosts);
//  }

  @override
  void dispose() {
//    _timelinepostsController.close();
//    _likeSymbolController.close();
    // TODO: implement dispose
  }


}