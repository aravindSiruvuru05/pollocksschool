import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/blocs/internet_connectivity_bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/user_model.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/phone_authentication_manager.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _useridEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
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
            color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.2),
              child: Form(
                key: _formKey,
                child: StreamBuilder<LoadingState>(
                  initialData: LoadingState.NORMAL,
                    stream: authBloc.loginButtonState,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: LoadingState.NORMAL == state ? CrossAxisAlignment.stretch : CrossAxisAlignment.center ,
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
                          PrimaryButton(
                            onTap: () async{
                              if (_formKey.currentState.validate())  {
                                authBloc.loginButtonStateSink.add(LoadingState.LOADING);
                                if(!await InternetConnectivity.isConnectedToInternet()) {
                                  authBloc.loginButtonStateSink.add(LoadingState.NORMAL);
                                  DialogPopUps.showCommonDialog(text: "Please make sure your are Connected to internet",ok: () => Navigator.pop(context),context: context);
                                  return;
                                }
                                final id = _useridEditingController.text;
                                final password = _passwordEditingController.text;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                final _userExist = await authBloc.isUserExist(id);
                                if(!_userExist){
                                  authBloc.loginButtonStateSink
                                      .add(LoadingState.NORMAL);
                                  DialogPopUps.showCommonDialog(text: "invalid User id",ok: () => Navigator.pop(context),context: context);
                                  return;
                                }
                                UserModel user = await authBloc.isValidUser(id,password);
                                if(user == null) {
                                  authBloc.loginButtonStateSink
                                      .add(LoadingState.NORMAL);
                                  DialogPopUps.showCommonDialog(text: "Incorrect Password",ok: () => Navigator.pop(context),context: context);
                                  _passwordEditingController.clear();
                                  return;
                                }
                                await PhoneAuthenticationManager.loginUser(
                                    "${authBloc.getCurrentUser.countrycode}${authBloc.getCurrentUser.phonenumber}", context);
                              }
                            },
                            text: "Login",
                            state: state,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                        ],
                      );
                    }),
              )),
        ),
      ),
    );
  }
}
