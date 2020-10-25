import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/blocs/loading_bloc.dart';
import 'package:pollocksschool/utils/DialogPopups.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
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
    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 2),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "OTP sent successfully to +9195333***",
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
                      authBloc.otpCancelButtonStateSink
                          .add(LoadingState.LOADING);
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: val);

                      UserCredential result =
                          await _auth.signInWithCredential(credential);

                      User user = result.user;
                      if (user != null) {
                        authBloc.otpCancelButtonStateSink
                            .add(LoadingState.DONE);
                        authBloc.checkCurrentUser();
                      } else {
                        authBloc.otpCancelButtonStateSink
                            .add(LoadingState.NORMAL);
                        DialogPopUps.showCommonDialog(
                            context: context,
                            text: "error ",
                            ok: () => Navigator.pop(context));
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      _pinEditingController.clear();
                      authBloc.otpCancelButtonStateSink
                          .add(LoadingState.NORMAL);
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

  _onSubmitTapped() {}
}
