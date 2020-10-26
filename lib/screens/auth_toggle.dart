import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'package:provider/provider.dart';

class AuthToggleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    authBloc.checkCurrentUser();
    return StreamBuilder<bool>(
      stream: authBloc.isAuthStream,
      builder: (context, snapshot) {
        final isAuthenticated = snapshot.data;
        if (isAuthenticated == null || isAuthenticated == false) {
          return LoginScreen();
        }
        return MainScreen();
      },
    );
  }
}
