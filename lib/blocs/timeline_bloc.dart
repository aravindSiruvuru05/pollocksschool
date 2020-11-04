

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/models/post_model.dart';

import 'bloc.dart';

class TimelineBloc extends Bloc{
  CollectionReference _timelineCollectionRef;

  UserModel currentUser;

  List<PostModel> allPosts;


  final _likeSymbolController =
  StreamController<bool>.broadcast();

  CollectionReference _postCollectionRef;
  Stream<bool> get likeSymbolStream =>
      _likeSymbolController.stream;
  Function get _likeSymbolSink => _likeSymbolController.sink.add;

  final _timelinepostsController =
  StreamController<List<PostModel>>.broadcast();
  Stream<List<PostModel>> get timelinePostsStream =>
      _timelinepostsController.stream;
  Function get _timelinePostsSink => _timelinepostsController.sink.add;


  TimelineBloc({@required this.currentUser}){
    _timelineCollectionRef = FirebaseFirestore.instance.collection("timeline");
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
    getTimelinePosts();
  }


  getIsLiked(Map<String,dynamic> likes){
    return likes[currentUser.id] == null ? false : likes[currentUser.id];
  }

  void handleLikePost(String postId, bool isLiked) async{
    print(postId);
    if(!isLiked){
      _likeSymbolSink(true);
      Timer(Duration(milliseconds: 600),(){
        _likeSymbolSink(false);
      });
    }
    await _postCollectionRef
        .doc(currentUser.id)
        .collection('userPosts')
        .doc(postId)
        .update({'likes.${currentUser.id}': !isLiked});
    getTimelinePosts();
  }

  getLikeCount(Map<String,dynamic> likes) async{
    int count = 0;
    // if no likes, return 0
    if (likes == null) {
      return count;
    }
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }
  
  getTimelinePosts() async {
    QuerySnapshot snapshot = await _timelineCollectionRef
        .doc(currentUser.classIds[0])
        .collection('classPosts')
        .orderBy('timestamp', descending: true)
        .get();
    final posts = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
    posts == null ? allPosts = [] : allPosts = posts;
    _timelinePostsSink(allPosts);
  }

  @override
  void dispose() {
    _timelinepostsController.close();
    _likeSymbolController.close();
    // TODO: implement dispose
  }


}