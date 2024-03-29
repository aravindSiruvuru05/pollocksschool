import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'utils/config/size_config.dart';
import 'utils/config/styling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//  await InternetConnectivity.isConnectedToInternet() ? runApp(MyApp()) : runApp(NoInternetWidget());
  runApp(MyApp());
}

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: Scaffold(
        body: Container(
          child: Center(
            child: Text("make sure you are connected to internet"),
          ),
        ),
      )
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints, Orientation.portrait);
        return  MultiProvider(
              providers: [
                Provider<AuthBloc>(create: (_) => AuthBloc()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                home: AuthToggleScreen(),
              ),
            );
          },
        );
      }
}
