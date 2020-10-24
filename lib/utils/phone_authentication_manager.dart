import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'config/size_config.dart';

class PhoneAuthenticationManager {
  static Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;

          if (user != null) {
            Provider.of<AuthBloc>(context, listen: false).checkCurrentUser();
          } else {
            print("Error");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print("$exception ----");
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return OtpModel(verificationId: verificationId, auth: _auth);
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        });
  }
}

class OtpModel extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final String verificationId;
  OtpModel({
    Key key,
    @required FirebaseAuth auth,
    this.verificationId,
  })  : _auth = auth,
        super(key: key);

  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return AlertDialog(
      title: Text("Code sent to +9195333****"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PrimaryTextFormField(
            controller: _controller,
            prefixIcon: Icons.offline_pin,
            labelText: "Enter code here",
            isObscureText: true,
          ),
        ],
      ),
      actions: <Widget>[
        PrimaryButton(
          text: "Submit",
          onTap: () async {
            final code = _controller.text.trim();
            AuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: code);

            UserCredential result =
                await _auth.signInWithCredential(credential);

            User user = result.user;

            if (user != null) {
              authBloc.checkCurrentUser();
            } else {
              print("Error");
            }
          },
        ),
      ],
    );
  }
}
