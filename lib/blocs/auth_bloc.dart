import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollocksschool/blocs/loading_bloc.dart';
import 'package:pollocksschool/models/user_model.dart';

class AuthBloc extends LoadingBloc {
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
    if (_userExist) loginButtonStateSink.add(LoadingState.DONE);
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
