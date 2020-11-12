import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/models/models.dart';

class TimelineBloc extends Bloc {
  CollectionReference timelineCollectionRef;
  CollectionReference postCollectionRef;


  UserModel currentUser;

  List<PostModel> timelinePosts;


  final _likeSymbolController =
  StreamController<String>.broadcast();
  Stream<String> get likeSymbolStream =>
      _likeSymbolController.stream;
  Function get _likeSymbolSink => _likeSymbolController.sink.add;


  final _timelinePostsState = StreamController<List<PostModel>>.broadcast();
  Stream<List<PostModel>> get timelinePostsStream =>
      _timelinePostsState.stream;
  Function get timelinePostsStateSink => _timelinePostsState.sink.add;

  TimelineBloc({@required this.currentUser}) {
    timelineCollectionRef = FirebaseFirestore.instance.collection("timeline");
    postCollectionRef = FirebaseFirestore.instance.collection("post");

    updateTimeline();
  }

  Future<void> updateTimeline() async{
    QuerySnapshot timelinePostsSnap = await timelineCollectionRef.doc("intilli3A").collection('classPosts')
        .orderBy('timestamp', descending: true).get();
    timelinePosts = timelinePostsSnap.docs.map<PostModel>((doc) => PostModel.fromDocument(doc)).toList();
    print(timelinePosts[0].commentscount);
    timelinePostsStateSink(timelinePosts);
  }



  void handleLikePost(PostModel post, bool isLiked) async{
    updatePostInFirestore(post,isLiked);
    if(isLiked){
      _likeSymbolSink(post.postId);
      Timer(Duration(milliseconds: 600),(){
        _likeSymbolSink("");
      });
    }
    timelinePosts = timelinePosts.map<PostModel>((e) {
      if(e.postId == post.postId){
       e.likes[currentUser.id] = isLiked;
      }
      return e;
    }).toList();
    timelinePostsStateSink(timelinePosts);
  }

  updatePostInFirestore(PostModel post, bool isLiked) async{
    await postCollectionRef
        .doc(post.ownerId)
        .collection('userPosts')
        .doc(post.postId)
        .update({'likes.${currentUser.id}': isLiked});
  }

  @override
  void dispose() {
    _timelinePostsState.close();
    _likeSymbolController.close();
    // TODO: implement dispose
  }
}