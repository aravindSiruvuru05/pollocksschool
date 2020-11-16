import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/models.dart';

class AuthBloc extends Bloc {

  FirebaseAuth _firebaseAuth;
  CollectionReference _userCollectionRef;
  CollectionReference _classCollectionRef;
  FirebaseMessaging _firebaseMessaging;
  UserModel _currentUser;
  final _isAuthenticated = StreamController<bool>();

  final _otpTimeout =
  StreamController<int>.broadcast();
  Stream<int> get otpTimeOutStream =>
      _otpTimeout.stream;
  Function get otpTimeoutSink => _otpTimeout.sink.add;

  Timer otpTimer;

  otpTImeout(){
    var timeleft = 60;
    otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeleft = timeleft - 1;
      if(timeleft == 0 ) timer.cancel();
          otpTimeoutSink(timeleft);
    });
  }

  // login button --------------
  final _loginButtonStateController =
      StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get loginButtonState =>
      _loginButtonStateController.stream;
  Function get loginButtonStateSink => _loginButtonStateController.sink.add;

  // otp cancel button --------------
  final _otpCancelButtonStateController =
      StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get otpCancelButtonState =>
      _otpCancelButtonStateController.stream;
  Function get otpCancelButtonStateSink =>
      _otpCancelButtonStateController.sink.add;

  Stream<bool> get isAuthStream => _isAuthenticated.stream;

  UserModel get getCurrentUser => _currentUser;

  AuthBloc() {
    _firebaseInit();
  }

  _firebaseInit(){
    _firebaseAuth= FirebaseAuth.instance;
    _firebaseMessaging = FirebaseMessaging();
    _userCollectionRef = FirebaseFirestore.instance.collection("user");
    _classCollectionRef = FirebaseFirestore.instance.collection("class");
  }

  Future<bool> isUserExist(String id) async{
    final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc("$id").get();
    return _userDocSnapshot.exists ? true : false ;
  }

  // ignore: missing_return
  Future<UserModel> isValidUser(String id,String password) async{
    try{
      final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc(id).get();
      final result = _userDocSnapshot.data();
      if(result["id"] == id && result["password"] == password) {
        _currentUser = UserModel.fromJson(result);
        return _currentUser;
      }
      return null ;
    } catch (e){
      print("======= $e");
    }
  }

  Future<UserModel> getCurrentUserDataWithId(String id) async{
    final DocumentSnapshot _userDocSnapshot = await _userCollectionRef.doc(id).get();
    final result = _userDocSnapshot.data();
    UserModel user = UserModel.fromJson(result);
    user.classes = [];
    for(id in user.classIds){
      DocumentSnapshot c = await _classCollectionRef.doc(id).get();
      final Map<String,dynamic> result = c.data();
      user.classes.add(ClassModel.fromJson(result));
    }
     return user;
  }

  // this method is the last one to trigger even sign in or sign out
  void checkCurrentUser() async {
    User _user = _firebaseAuth.currentUser;
    final _userExist = _user != null ? true : false;
    if(_userExist) {
      _currentUser = await getCurrentUserDataWithId(_user.displayName);
      Timer(Duration(milliseconds: 200),(){
        enablePushtoken();
        loginButtonStateSink(LoadingState.DONE);
      });
    } else {
      loginButtonStateSink(LoadingState.NORMAL);
    }
    Timer(Duration(milliseconds: 150), (){
      _isAuthenticated.sink.add(_userExist);
    });
  }

  enablePushtoken(){
    _firebaseMessaging.getToken().then((value){
      _userCollectionRef
          .doc(_currentUser.id)
          .update({'pushToken': value});
    });
  }

  removePushToken(){
    _userCollectionRef
        .doc(_currentUser.id)
        .update({'pushToken': ''});
  }


  void signOut() async {
    removePushToken();
    await _firebaseAuth.signOut();
    _isAuthenticated.sink.add(false);
  }

  @override
  void dispose() {
    _loginButtonStateController.close();
    _otpCancelButtonStateController.close();
    otpTimer.cancel();
    _otpTimeout.close();
    _isAuthenticated.close();
    // TODO: implement dispose
  }
}
