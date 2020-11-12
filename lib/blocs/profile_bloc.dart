

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollocksschool/models/models.dart';
import 'blocs.dart';

class ProfileBloc extends Bloc{

  UserModel currentUser;

  CollectionReference _postCollectionRef;
  QuerySnapshot postsSnapshot;

  int _postCount;

  int get getPostCount => _postCount;

  Stream<QuerySnapshot> get postsStream => _postCollectionRef.doc(currentUser.id)
      .collection('userPosts')
      .orderBy('timestamp', descending: true).snapshots();

  ProfileBloc({this.currentUser}){
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  updatePostInFirestore(PostModel post, bool isLiked) async{
  print(post.postId);
  print(isLiked);
  await _postCollectionRef
      .doc(post.ownerId)
      .collection('userPosts')
      .doc(post.postId)
      .update({'likes.${currentUser.id}': !isLiked});
//    getPosts();
}

}