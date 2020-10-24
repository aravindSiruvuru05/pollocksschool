import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
                      height: SizeConfig.heightMultiplier * 1.7,
                    ),
                    PrimaryButton(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          print("validated");
                        }
                      },
                      text: "Login",
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
