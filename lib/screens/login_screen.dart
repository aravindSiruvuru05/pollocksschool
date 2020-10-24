//import 'package:flutter/material.dart';
//import 'package:pollocksschool/blocs/auth_bloc.dart';
//import 'package:pollocksschool/utils/config/size_config.dart';
//import 'package:pollocksschool/utils/config/strings.dart';
//import 'package:pollocksschool/widgets/widgets.dart';
//import 'package:provider/provider.dart';
//
//import 'main_screen.dart';

//class LoginScreen extends StatelessWidget {
//  final _formKey = GlobalKey<FormState>();
//  TextEditingController _useridEditingController = TextEditingController();
//  TextEditingController _passwordEditingController = TextEditingController();
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: GestureDetector(
//        onTap: () {
//          FocusScope.of(context).requestFocus(new FocusNode());
//        },
//        child: Container(
//            padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.2),
//            child: Form(
//              key: _formKey,
//              child: Center(
//                child: ListView(
//                  shrinkWrap: true,
//                  children: <Widget>[
//                    Image(
//                      image: AssetImage(Strings.getLogoImagePath),
//                      height: SizeConfig.imageSizeMultiplier * 60,
//                    ),
//                    PrimaryTextFormField(
//                      labelText: "Enter User Id",
//                      controller: _useridEditingController,
//                      isObscureText: false,
//                      prefixIcon: Icons.account_circle,
//                      validator: (value) {
//                        if (value.length < 5) {
//                          return 'Please enter valid id';
//                        }
//                        return null;
//                      },
//                    ),
//                    SizedBox(
//                      height: SizeConfig.heightMultiplier * 1.5,
//                    ),
//                    PrimaryTextFormField(
//                      labelText: "Enter Password",
//                      controller: _passwordEditingController,
//                      isObscureText: true,
//                      prefixIcon: Icons.lock_outline,
//                      validator: (value) {
//                        if (!value.contains(
//                                new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ||
//                            value.length < 5) {
//                          return Strings.getPasswordErrorText;
//                        }
//                        return null;
//                      },
//                    ),
//                    SizedBox(
//                      height: SizeConfig.heightMultiplier * 2.5,
//                    ),
//                    PrimaryButton(
//                      onTap: () {
//                        if (_formKey.currentState.validate()) {
//                          final userId = _useridEditingController.text;
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (context) => MainScreen()),
//                        );
//                        }
//                      },
//                      text: "Login",
//                    ),
//                    SizedBox(
//                      height: SizeConfig.heightMultiplier * 5,
//                    ),
//                  ],
//                ),
//              ),
//            )),
//      ),
//    );
//  }
//}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;

          if(user != null){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => HomeScreen()
            ));
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
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
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MainScreen()
                          ));
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: (String verificationId){}
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBloc>(context);
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

                  SizedBox(height: 16,),

                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[200])
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[300])
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Mobile Number"

                    ),
                    controller: _phoneController,
                  ),

                  SizedBox(height: 16,),


                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text("LOGIN"),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        final phone = _phoneController.text.trim();

                        loginUser(phone, context);

                      },
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}