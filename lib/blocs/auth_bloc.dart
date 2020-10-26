import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/user_model.dart';

class AuthBloc extends Bloc {

  FirebaseAuth _firebaseAuth;
  CollectionReference _userCollectionRef;

  UserModel _currentUser = UserModel();
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

  Future<UserModel> getUserDataWithIdPassword(String id,String password) async{
    final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc("$id").get();
//    UserModel userModel = UserModel.fromJson(json)
    print(_userDocSnapshot);
    return UserModel();
  }

  void checkCurrentUser() async {
    User _user = _firebaseAuth.currentUser;
    final _userExist = _user != null ? true : false;

    if (_userExist) loginButtonStateSink.add(LoadingState.DONE);
    _isAuthenticated.sink.add(_userExist);
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
