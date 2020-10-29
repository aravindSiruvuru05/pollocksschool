import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/enums/user_type.dart';
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
//        if(snapshot.connectionState == ConnectionState.waiting)
        final isAuthenticated = snapshot.data;
        if(isAuthenticated == null )
          return ProfileScreen();
        if ( isAuthenticated == false)
          return LoginScreen();
        final UserType userType = authBloc.getCurrentUser.userType;
        return MainScreen();
      },
    );
  }
}
