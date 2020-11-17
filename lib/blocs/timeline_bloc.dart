import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/enums/user_type.dart';
import 'package:pollocksschool/models/models.dart';

class TimelineBloc extends Bloc {
  CollectionReference timelineCollectionRef;
  CollectionReference postCollectionRef;
  CollectionReference activityFeedRef;


  UserModel currentUser;
  List<PostModel> timelinePosts;
  List<String> savedPostsIds = [];


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
    activityFeedRef = FirebaseFirestore.instance.collection("feed");
    postCollectionRef = FirebaseFirestore.instance.collection("post");
    _init();
    timelineCollectionRef.doc("intilli3A").collection('classPosts')
        .orderBy('timestamp', descending: true).snapshots().listen((querySnapshot) {
      updateTimeline(querySnapshot);
    });
//    getAdminTimeline();
  }

//  getAdminTimeline() async{
//
//    FirebaseFirestoreeFirestore.instance.collection("user")
//        .where("classIds",arrayContains: "intilli3A")
//        .where("pushToken",isGreaterThan: "")
//        .get()
//        .then((val){
//      print(val.docs.length);
//    });
//
//
////    List<QuerySnapshot> snapsList = [];
////   QuerySnapshot timelineSnap = await timelineCollectionRef.get();
////   timelineSnap.docs.forEach((doc) async{
////     final a = await doc.reference.collection("classPosts").get();
////     snapsList.add(a);
////   });
////   return snapsList.length;
//  }

  _init() async{
   if(currentUser.userType == UserType.STUDENT){
     QuerySnapshot snap = await postCollectionRef.doc(currentUser.id).collection("userPosts").get();
     snap.docs.forEach((doc) {
       savedPostsIds.add(doc.id);
     });
   }
    final snapshot = await getTimelineQuerySnapshot();
    updateTimeline(snapshot);
  }

  Future<QuerySnapshot> getTimelineQuerySnapshot() async{
    return await timelineCollectionRef.doc("intilli3A").collection('classPosts')
        .orderBy('timestamp', descending: true).get();
  }

  Future<void> updateTimeline(QuerySnapshot snapshot) async{

    timelinePosts = snapshot.docs.map<PostModel>((doc) => PostModel.fromDocument(doc)).toList();
    timelinePosts = timelinePosts == null ? [] : timelinePosts;
    timelinePostsStateSink(timelinePosts);
  }

  Future<void> toggleSaveToPostCollection(PostModel post,bool isSaved) async{
    if(isSaved){
      await postCollectionRef
          .doc(currentUser.id)
          .collection("userPosts")
          .doc(post.postId)
          .get()
          .then( (doc) {
            if (doc.exists) {
             doc.reference.delete().then((value) {
               savedPostsIds.remove(post.postId);
               timelinePostsStateSink(timelinePosts);
             });
            }
          });
    }else{
      final postMap = post.toMap();
      await postCollectionRef
          .doc(currentUser.id)
          .collection("userPosts")
          .doc(post.postId)
          .set(postMap)
          .then((value) {
            savedPostsIds.add(post.postId);
            timelinePostsStateSink(timelinePosts);
          },
          onError: (value) {
            print("failed");
          });
    }
  }

  void handleLikePost(PostModel post, bool isLiked) async{
    updatePostInFirestore(post,isLiked);
    if(isLiked){
      HapticFeedback.heavyImpact();
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
    await timelineCollectionRef
          .doc(post.classId)
          .collection('classPosts')
          .doc(post.postId)
          .update({'likes.${currentUser.id}': isLiked});
    isLiked ? addLikeToActivityFeed(post) : removeLikeFromActivityFeed(post);
  }

  removeLikeFromActivityFeed(PostModel post) {
    bool isNotPostOwner = currentUser.id != post.ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(post.ownerId)
          .collection("feedItems")
          .doc(post.postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  addLikeToActivityFeed(PostModel post) {
    print("d");
    // add a notification to the postOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    bool isNotPostOwner = currentUser.id != post.ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(post.ownerId)
          .collection("feedItems")
          .doc(post.postId)
          .set({
        "type": "LIKE",
        "caption": "",
        "username": "${currentUser.firstname} ${currentUser.lastname}",
        "userId": currentUser.id,
        "userProfileImg": currentUser.photourl,
        "postId": post.postId,
        "mediaUrl": post.mediaUrl,
        "timestamp": DateTime.now(),
      });
    }
  }

  @override
  void dispose() {
    _timelinePostsState.close();
    _likeSymbolController.close();
    // TODO: implement dispose
  }
}