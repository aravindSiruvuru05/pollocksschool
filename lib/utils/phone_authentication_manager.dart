import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/screens/login_screen.dart';
import 'package:pollocksschool/screens/phone_auth_screen.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:provider/provider.dart';

class PhoneAuthenticationManager {
  static Future<void> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _codeController = TextEditingController();
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context);
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;
          if (user != null) {
            if(user.displayName == null) await user.updateProfile(displayName: authBloc.getCurrentUser.id);
            authBloc.checkCurrentUser();
          } else {
            DialogPopUps.showCommonDialog(context: context, text: "verification complete and error fetching user ");
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
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "OTP sent successfully to ${phone.substring(0,4)}***",
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async{
                          final code = _codeController.text.trim();
                          AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

                          UserCredential result = await _auth.signInWithCredential(credential);

                          User user = result.user;

                          if(user != null){
                              if(user.displayName == null) await user.updateProfile(displayName: authBloc.getCurrentUser.id);
                              Navigator.pop(context);
                              authBloc.checkCurrentUser();
                          }else{
                            print("Error");
                          }
                        },
                      )
                    ],
                  );
                }
            );
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => PhoneAuthScreen(
//                        verificationId: verificationId,
//                      ),
//              ),
//          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
    );
  }
}
