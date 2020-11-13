import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/blocs/profile_bloc.dart';
import 'package:pollocksschool/blocs/timeline_bloc.dart';
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
        if (isAuthenticated == null) return LoadingScreen();
        if (isAuthenticated) {
          final currentUser = authBloc.getCurrentUser;

          return MultiProvider(
            providers: [
              Provider<TimelineBloc>(
                  create: (_) => TimelineBloc(currentUser: currentUser)),
              Provider<ProfileBloc>(
                  create: (_) => ProfileBloc(currentUser: currentUser)),
            ],
            child: MainScreen(
              currentuser: authBloc.getCurrentUser,
            ),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
