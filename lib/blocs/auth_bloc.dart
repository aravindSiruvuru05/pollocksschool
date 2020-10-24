import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollocksschool/models/user_model.dart';
import 'bloc.dart';

class AuthBloc extends Bloc {
  UserModel _currentUser = UserModel();
  final _isAuthenticated = StreamController<bool>();

  Stream<bool> get isAuthStream => _isAuthenticated.stream;

  UserModel get getCurrentUser => _currentUser;

  AuthBloc() {
    checkCurrentUser();
  }

  void checkCurrentUser() async {
    User _user = FirebaseAuth.instance.currentUser;
    final _userExist = _user != null ? true : false;
    print(_user);
    if (_userExist) _currentUser.mobile = _user.phoneNumber;
    _isAuthenticated.sink.add(_userExist);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    _isAuthenticated.sink.add(false);
  }

  @override
  void dispose() {
    _isAuthenticated.close();
    // TODO: implement dispose
  }
}
