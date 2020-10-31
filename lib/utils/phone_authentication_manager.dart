import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'config/styling.dart';

class PhoneAuthenticationManager {
  static Future<void> loginUser(String phonenumber, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _codeController = TextEditingController();
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);

    _auth.verifyPhoneNumber(
      phoneNumber: phonenumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        authBloc.otpTimer.cancel();
        Navigator.pop(context);
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
        authBloc.loginButtonStateSink(LoadingState.NORMAL);
        DialogPopUps.showCommonDialog(
            context: context,
            text: exception.toString(),
            ok: () => Navigator.pop(context));
      },
      codeSent: (String verificationId, [int forceResendingToken]) {

        authBloc.otpTImeout();
        showDialog(
            context: context,

            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "OTP sent successfully to ${phonenumber.substring(0,7)}***",
                  style: AppTheme.lightTextTheme.headline6,
                ),
                elevation: 10,
                contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("sit back and relax ... we will auto validate if the above number is in the current device...",style: AppTheme.otpsubtitle,),
                    SizedBox(height: 5,),
                    PinInputTextField(
                      controller: _codeController,
                      autoFocus: true,
                      pinLength: 6,
                      keyboardType: TextInputType.number,
                      inputFormatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (val) async {
                        if (val.length == 6) {
                          try {
                            authBloc.otpCancelButtonStateSink(LoadingState.LOADING);
                            AuthCredential credential = PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: val);

                            UserCredential result =
                            await _auth.signInWithCredential(credential);
                            User user = result.user;
                            if (user != null) {
                              if(user.displayName == null) await user.updateProfile(displayName: authBloc.getCurrentUser.id);
                              print(user);
                              authBloc.otpCancelButtonStateSink(LoadingState.DONE);
                              Timer(Duration(milliseconds: 300), () {
                                Timer(Duration(milliseconds: 300), () {
                                  authBloc.checkCurrentUser();
                                });
                                Navigator.pop(context);
                              });
                            } else {
                              authBloc.loginButtonStateSink(LoadingState.NORMAL);
                              authBloc.otpCancelButtonStateSink(LoadingState.NORMAL);
                              DialogPopUps.showCommonDialog(
                                  context: context,
                                  text: "error ",
                                  ok: () => Navigator.pop(context));
                            }
                          } catch (e) {
                            _codeController.clear();
                            authBloc.otpCancelButtonStateSink(LoadingState.NORMAL);
                            print(e.message);
                            DialogPopUps.showCommonDialog(
                                context: context,
                                text: e.toString(),
                                ok: () => Navigator.pop(context));
                          }
                        }
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  StreamBuilder<int>(
                    initialData: 60,
                    stream: authBloc.otpTimeOutStream,
                    builder: (context, snapshot) {
                      return snapshot.data == 0 ?
                      InkWell(onTap: () {
                        Navigator.pop(context);
                        authBloc.otpTimer.cancel();
                      },child: Text("try again",style: AppTheme.lightTextTheme.button
                          .copyWith(color: AppTheme.primaryColor),)) :
                      Text(snapshot.data.toString(),style: AppTheme.lightTextTheme.button
                          .copyWith(color: AppTheme.primaryColor),) ;
                    }
                  ),
                  StreamBuilder<LoadingState>(
                      stream: authBloc.otpCancelButtonState,
                      initialData: LoadingState.NORMAL,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        return SecondaryButton(
                          onTap: () {
                            Navigator.pop(context);
                            authBloc.otpTimer.cancel();
                            Timer(Duration(milliseconds: 300),(){
                              authBloc.loginButtonStateSink(LoadingState.NORMAL);
                            });
                          },
                          text: "Cancel",
                          state: state,
                        );
                      }
                      ),
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
