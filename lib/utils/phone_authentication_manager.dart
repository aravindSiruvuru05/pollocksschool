import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/screens/phone_auth_screen.dart';
import 'package:pollocksschool/utils/DialogPopups.dart';
import 'package:provider/provider.dart';

class PhoneAuthenticationManager {
  static Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);

          if (result.user != null) {
            authBloc.checkCurrentUser();
          } else {
            DialogPopUps.showCommonDialog(context: context, text: "error ");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          authBloc.loginButtonStateSink.add(LoadingState.NORMAL);
          DialogPopUps.showCommonDialog(
              context: context,
              text: exception.toString(),
              ok: () => Navigator.pop(context));
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhoneAuthScreen(
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        });
  }
}
