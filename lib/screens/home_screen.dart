import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  
  HomeScreen({Key key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Container(
        child: Text(authBloc.getCurrentUser.classes[0].name.toString()),
      ),
    );
  }
}

