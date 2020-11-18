import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddProfilePhotoScreen extends StatelessWidget {

  UploadBloc _uploadBloc;
  AuthBloc _authBloc;

  final TextEditingController _captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _uploadBloc = Provider.of<UploadBloc>(context);
    _authBloc = Provider.of<AuthBloc>(context);
    return
      StreamBuilder<bool>(
          stream: _uploadBloc.isfileExist,
          initialData: false,
          builder: (context, snapshot) {
            final isFileExist = snapshot.data;
            if(isFileExist){
              return buildUploadForm(context);
            }
            return buildSplashScreen(context);
          }
      );
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Photo with Camera"),
              onPressed:() {
                Navigator.pop(context);
                _uploadBloc.handleTakePhoto();
              },
            ),
            SimpleDialogOption(
              child: Text("Image from Gallery"),
              onPressed:() {
                Navigator.pop(context);
                _uploadBloc.handleChooseFromGallery();
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Scaffold buildSplashScreen(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () => selectImage(context)),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold buildUploadForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Add Profile Photo",
          style: AppTheme.lightTextTheme.headline6,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_uploadBloc.file),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () async{
//                  final hasCaption = _captionController.value.text.isNotEmpty;
                if(!await InternetConnectivity.isConnectedToInternet()) {
                  CustomFlushBar.customFlushBar(message: "Please make sure your are Connected to internet", type: FlushBarType.INFO);
                  return;
                }
                DialogPopUps.showLoadingDialog(context: context);
                final uploaded = await _uploadBloc.uploadProfilePhoto(_authBloc.getCurrentUser);
                _authBloc.checkCurrentUser();
                Timer(Duration(milliseconds: 500),(){
                  DialogPopUps.removeLoadingDialog(context: context);
                  if(uploaded){
                    CustomFlushBar.customFlushBar(message: "Profile photo updated", type: FlushBarType.SUCCESS);
                  } else {
                    CustomFlushBar.customFlushBar(message: "Upload Failed !", type: FlushBarType.FAILURE);
                  }
                  _uploadBloc.isfileExistSink(false);
                });
              },
              child: Text(
                "Post",
                style: AppTheme.lightTextTheme.headline6.copyWith(color: Colors.blueAccent),
              ),
            )
          ],
        )
      ),
    );
  }

}
