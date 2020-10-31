

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/models/post_model.dart';

import 'blocs.dart';

class ProfileBloc extends Bloc{

  UserModel currentUser;

  CollectionReference _postCollectionRef;

  int _postCount;

  int get getPostCount => _postCount;

  List<PostModel> allPosts = [];

  final _postsController =
  StreamController<List<PostModel>>.broadcast();
  Stream<List<PostModel>> get postsStream =>
      _postsController.stream;
  Function get _postsSink => _postsController.sink.add;

  ProfileBloc({@required this.currentUser}){
    _init();
  }

  _init(){
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
    getProfilePosts();
  }

  @override
  void dispose() {
    _postsController.close();
    // TODO: implement dispose
  }

   getProfilePosts() async {
    print("sadf");
    QuerySnapshot snapshot = await _postCollectionRef
        .doc(currentUser.id)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    _postCount = snapshot.docs.length;
    print(snapshot.docs[0].data());
    final posts = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
    allPosts = posts;
    _postsSink(allPosts);
  }


}