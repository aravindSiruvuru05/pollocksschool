import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollocksschool/blocs/post_bloc.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/models/post_model.dart';

class ProfileBloc extends PostBloc{

  UserModel currentUser;

  CollectionReference _postCollectionRef;
  QuerySnapshot postsSnapshot;

  int _postCount;

  int get getPostCount => _postCount;

  List<PostModel> allPosts;

  //heart beat for like

//  final _likeSymbolController =
//  StreamController<bool>.broadcast();
//  Stream<bool> get likeSymbolStream =>
//      _likeSymbolController.stream;
//  Function get _likeSymbolSink => _likeSymbolController.sink.add;
//  final _postsController =
//  StreamController<List<PostModel>>.broadcast();
  Stream<QuerySnapshot> get postsStream => _postCollectionRef.doc(currentUser.id)
      .collection('userPosts')
      .orderBy('timestamp', descending: true).snapshots();
//  Function get _postsSink => _postsController.sink.add;

  ProfileBloc({this.currentUser}): super(currentUser: currentUser){
    _init();
  }

  _init(){
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
//    getPosts();
  }

  @override
  void dispose() {
//    _postsController.close();
//    _likeSymbolController.close();
    // TODO: implement dispose
  }

  updatePost(PostModel post, bool isLiked) async{
    print(post.postId);
    print(isLiked);
    await _postCollectionRef
        .doc(post.ownerId)
        .collection('userPosts')
        .doc(post.postId)
        .update({'likes.${currentUser.id}': !isLiked});
//    getPosts();
  }
//
//  getPosts() async{
//    postsSnapshot = await _postCollectionRef
//        .doc(currentUser.id)
//        .collection('userPosts')
//        .orderBy('timestamp', descending: true)
//        .get();
//    _postCount = postsSnapshot.docs.length;
//    print(_postCount);
//    final posts = postsSnapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
//    posts == null ? allPosts = [] : allPosts = posts;
//    _postsSink(allPosts);
//  }


//  getIsLiked(Map<String,dynamic> likes){
//    return likes[currentUser.id] == null ? false : likes[currentUser.id];
//  }
//
//  void handleLikePost(PostModel post, bool isLiked) async{
//    if(!isLiked){
//      _likeSymbolSink(true);
//      Timer(Duration(milliseconds: 600),(){
//        _likeSymbolSink(false);
//      });
//    }
//   await _postCollectionRef
//        .doc(post.ownerId)
//        .collection('userPosts')
//        .doc(post.postId)
//        .update({'likes.${currentUser.id}': !isLiked});
//   getPosts();
//  }
//
//  getLikeCount(Map<String,dynamic> likes) async{
//    int count = 0;
//    // if no likes, return 0
//    if (likes == null) {
//      return count;
//    }
//    // if the key is explicitly set to true, add a like
//    likes.values.forEach((val) {
//      if (val == true) {
//        count += 1;
//      }
//    });
//    return count;
//  }

}