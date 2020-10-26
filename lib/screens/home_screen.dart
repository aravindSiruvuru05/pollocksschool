import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi +919533376764"),
//              StreamBuilder<LoadingState>(
//                stream: authBloc.loginButtonState,
//                initialData: LoadingState.NORMAL,
//                builder: (context, snapshot) {
//                  final state = snapshot.data;
//                  return PrimaryButton(
//                    text: "Submit",
//                    onTap: () {
//                      Timer(Duration(seconds: 2), () {
//                        authBloc.loginButtonStateSink.add(LoadingState.LOADING);
//                        Timer(Duration(seconds: 2), () {
//                          authBloc.loginButtonStateSink.add(LoadingState.DONE);
//                        });
//                      });
//                    },
//                    state: state,
//                  );
//                },
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
