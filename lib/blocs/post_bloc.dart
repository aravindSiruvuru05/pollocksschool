

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/models/post_model.dart';

abstract class PostBloc extends Bloc {
  UserModel currentUser;

  CollectionReference _postCollectionRef;


  PostBloc({this.currentUser}){
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
  }

  final _likeSymbolController =
  StreamController<bool>.broadcast();
  Stream<bool> get likeSymbolStream =>
      _likeSymbolController.stream;
  Function get _likeSymbolSink => _likeSymbolController.sink.add;

  getIsLiked(Map<String,dynamic> likes){
    return likes[currentUser.id] == null ? false : likes[currentUser.id];
  }

  void handleLikePost(PostModel post, bool isLiked) async{
    print(post.postId);
    print(isLiked);
    if(!isLiked){
      _likeSymbolSink(true);
      Timer(Duration(milliseconds: 600),(){
        _likeSymbolSink(false);
      });
    }
    await _postCollectionRef
        .doc(post.ownerId)
        .collection('userPosts')
        .doc(post.postId)
        .update({'likes.${currentUser.id}': !isLiked});
    getPosts();
  }

  getPosts();

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

  @override
  void dispose() {
    _likeSymbolController.close();
    // TODO: implement dispose
  }

}