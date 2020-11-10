import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/user_model.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:pollocksschool/widgets/secondary_button.dart';
import 'package:provider/provider.dart';

class PhoneAuthScreen extends StatelessWidget {
  final String verificationId;

  PhoneAuthScreen({this.verificationId});

  final TextEditingController _pinEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    final UserModel currentUser = authBloc.getCurrentUser;
    print(currentUser.countrycode);

    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 2),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "OTP sent successfully to ${currentUser.countrycode}${currentUser.phonenumber.substring(0,7)}***",
                style: AppTheme.lightTextTheme.headline6,
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier,
              ),
              PinInputTextField(
                controller: _pinEditingController,
                autoFocus: true,
                pinLength: 6,
                keyboardType: TextInputType.number,
                inputFormatter: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (val) async {
                  if (val.length == 6) {
                    try {
                      authBloc.loginButtonStateSink(LoadingState.NORMAL);
                      authBloc.otpCancelButtonStateSink(LoadingState.LOADING);
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: val);

                      UserCredential result =
                          await _auth.signInWithCredential(credential);
                      User user = result.user;
                      if (user != null) {
                       if(user.displayName == null) await user.updateProfile(displayName: authBloc.getCurrentUser.id);
                        authBloc.otpCancelButtonStateSink(LoadingState.DONE);
                      } else {
                        authBloc.otpCancelButtonStateSink(LoadingState.NORMAL);
                        DialogPopUps.showCommonDialog(
                            context: context,
                            text: "error ",
                            ok: () => Navigator.pop(context));
                      }
                      Timer(Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                        authBloc.checkCurrentUser();
                      });
                    } catch (e) {
                      _pinEditingController.clear();
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
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: SizeConfig.heightMultiplier,
                  ),
                  StreamBuilder<LoadingState>(
                      stream: authBloc.otpCancelButtonState,
                      initialData: LoadingState.NORMAL,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        return SecondaryButton(
                          onTap: () { 
                            Navigator.pop(context);
                            Timer(Duration(milliseconds: 300),(){
                              authBloc.loginButtonStateSink(LoadingState.NORMAL);
                            });
                          },
                          text: "Cancel",
                          state: state,
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
