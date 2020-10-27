import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/user_model.dart';

class AuthBloc extends Bloc {

  FirebaseAuth _firebaseAuth;
  CollectionReference _userCollectionRef;

  UserModel _currentUser;
  final _isAuthenticated = StreamController<bool>();

  // login button --------------
  final _loginButtonStateController =
      StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get loginButtonState =>
      _loginButtonStateController.stream;
  StreamSink get loginButtonStateSink => _loginButtonStateController.sink;

  // otp cancel button --------------
  final _otpCancelButtonStateController =
      StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get otpCancelButtonState =>
      _otpCancelButtonStateController.stream;
  StreamSink get otpCancelButtonStateSink =>
      _otpCancelButtonStateController.sink;

  Stream<bool> get isAuthStream => _isAuthenticated.stream;

  UserModel get getCurrentUser => _currentUser;

  AuthBloc() {
    _firebaseInit();
  }

  _firebaseInit(){
    _firebaseAuth= FirebaseAuth.instance;
    _userCollectionRef = FirebaseFirestore.instance.collection("user");
  }

  Future<bool> isUserExist(String id) async{
    final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc("$id").get();
    return _userDocSnapshot.exists ? true : false ;
  }

  Future<UserModel> isValidUser(String id,String password) async{
    try{
      final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc(id).get();
      final result = _userDocSnapshot.data();
      if(result["id"] == id && result["password"] == password) {
        _currentUser = UserModel.fromJson(result);
        print(result);
        return _currentUser;
      }
      return null ;
    } catch (e){
      print("======= $e");
    }
  }

  // this method is the last one to trigger even sign in or sign out
  void checkCurrentUser() async {
    User _user = _firebaseAuth.currentUser;

    final _userExist = _user != null ? true : false;
    if(_userExist) {
      final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc(_user.displayName).get();
      final result = _userDocSnapshot.data();
      _currentUser = UserModel.fromJson(result);
      loginButtonStateSink.add(LoadingState.DONE);
    } else {
      loginButtonStateSink.add(LoadingState.NORMAL);
    }
    Timer(Duration(milliseconds: 150), (){
      _isAuthenticated.sink.add(_userExist);
    });
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    _isAuthenticated.sink.add(false);
  }

  @override
  void dispose() {
    _loginButtonStateController.close();
    _otpCancelButtonStateController.close();
    _isAuthenticated.close();
    // TODO: implement dispose
  }
}
