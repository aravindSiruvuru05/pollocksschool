import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc.dart';

class AuthBloc extends Bloc {
  var val;

  final _isAuthenticated = StreamController<bool>();

  Stream<bool> get isAuthStream => _isAuthenticated.stream;

  AuthBloc(){
    val = 1;
    print(FirebaseAuth.instance.currentUser.toString());

  }

  void _onCurrentUserChanged() {

  }

  void signInWithGoogle() async {
    val += 1;
    _isAuthenticated.sink.add(val);
  }

  void signOut() async {

  }

  @override
  void dispose() {
    _isAuthenticated.close();
    // TODO: implement dispose
  }
}