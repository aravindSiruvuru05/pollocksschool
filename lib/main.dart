import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';
import 'utils/config/size_config.dart';
import 'utils/config/styling.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MultiProvider(
              providers: [
                Provider<AuthBloc>(create: (_) => AuthBloc()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                home: LoginScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
