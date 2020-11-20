import 'package:flutter/cupertino.dart';
import '../models/models.dart';
import 'bloc.dart';

class ActivityBloc extends Bloc {
  final UserModel currentUser;
  ActivityBloc({@required this.currentUser});
  @override
  void dispose() {
    // TODO: implement dispose
  }

}