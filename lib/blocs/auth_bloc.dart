import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollocksschool/blocs/bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/user_model.dart';

class AuthBloc extends Bloc {
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
    _loginButtonStateController.close();
    _otpCancelButtonStateController.close();
    _isAuthenticated.close();
    // TODO: implement dispose
  }
}
