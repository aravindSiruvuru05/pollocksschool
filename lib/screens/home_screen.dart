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
              PrimaryButton(state: LoadingState.LOADING,)
            ],
          ),
        ),
      ),
    );
  }
}

