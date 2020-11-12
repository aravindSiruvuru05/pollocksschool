import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/models.dart';

abstract class PostBloc extends Bloc {
  UserModel currentUser;

  CollectionReference _postCollectionRef;

  LoadingState _likeButtonState;


  PostBloc({this.currentUser}){
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
  }


  // like button --------------
  final _likebuttonState =
  StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get likebuttonStateStream =>
      _likebuttonState.stream;
  Function get liketbuttonStateSink => _likebuttonState.sink.add;

  final _likeSymbolController =
  StreamController<String>.broadcast();
  Stream<String> get likeSymbolStream =>
      _likeSymbolController.stream;
  Function get _likeSymbolSink => _likeSymbolController.sink.add;

  getIsLiked(Map<String,dynamic> likes){
    return likes[currentUser.id] == null ? false : likes[currentUser.id];
  }


  void handleLikePost(PostModel post, bool isLiked) async{
    print("handle");
    liketbuttonStateSink(LoadingState.LOADING);
    _likeButtonState = LoadingState.LOADING;
    Timer(Duration(milliseconds: 4000),(){
      liketbuttonStateSink(LoadingState.NORMAL);
      _likeButtonState = LoadingState.NORMAL;
    });
    if(!isLiked){
      _likeSymbolSink(post.postId);
      Timer(Duration(milliseconds: 600),(){
        _likeSymbolSink("");
      });
    }
    updatePost(post,isLiked);
  }

  updatePost(PostModel post,bool isLiked);

  @override
  void dispose() {
    _likeSymbolController.close();
    _likebuttonState.close();
    // TODO: implement dispose
  }

}