import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/phone_authentication_manager.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _useridEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.2),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(Strings.getLogoImagePath),
                      height: SizeConfig.imageSizeMultiplier * 60,
                    ),
                    PrimaryTextFormField(
                      labelText: "Enter User Id",
                      controller: _useridEditingController,
                      isObscureText: false,
                      prefixIcon: Icons.account_circle,
                      validator: (value) {
                        if (value.length < 5) {
                          return 'Please enter valid id';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    PrimaryTextFormField(
                      labelText: "Enter Password",
                      controller: _passwordEditingController,
                      isObscureText: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (!value.contains(
                                new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ||
                            value.length < 5) {
                          return Strings.getPasswordErrorText;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2.5,
                    ),
                    StreamBuilder<LoadingState>(
                        initialData: LoadingState.NORMAL,
                        stream: authBloc.loginButtonState,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          return PrimaryButton(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                authBloc.loginButtonStateSink
                                    .add(LoadingState.LOADING);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                PhoneAuthenticationManager.loginUser(
                                    "+16505553434", context);
                              }
                            },
                            text: "Login",
                            state: state,
                          );
                        }),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 5,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
