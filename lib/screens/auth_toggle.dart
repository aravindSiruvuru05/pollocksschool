import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:provider/provider.dart';

class AuthToggleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    authBloc.checkCurrentUser();
    return Scaffold(
      key: Constants.authToggleScreenScaffoldKey,
      body: StreamBuilder<bool>(
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
                Provider<ActivityBloc>(
                    create: (_) => ActivityBloc(currentUser: currentUser)),
                Provider<ProfileBloc>(
                    create: (_) => ProfileBloc(currentUser: currentUser)),
                Provider<UploadBloc>(
                    create: (_) => UploadBloc()),
              ],
              child: currentUser.photourl.isEmpty ? AddProfilePhotoScreen() :  MainScreen(
                currentuser: authBloc.getCurrentUser,
              ),
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
