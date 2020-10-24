import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/widgets/widgets.dart';

import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _useridEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.2),
            child: Form(
              key: _formKey,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
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
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          final userId = _useridEditingController.text;
                          print(userId);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                        }
                      },
                      text: "Login",
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 5,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
