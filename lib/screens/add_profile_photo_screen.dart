import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class AddProfilePhotoScreen extends StatelessWidget {

  UploadBloc _uploadBloc;
  AuthBloc _authBloc;

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
            return buildSplashScreen(context,isFileExist);
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

  Widget buildSplashScreen(BuildContext context,bool isFileExist) {

    return Scaffold(
      appBar:  AppBar(
        title: Text("Add Profile Photo",
            style: AppTheme.lightTextTheme.headline6.copyWith(
                fontFamily: Constants.getHelveticaNeueFamily,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: SizeConfig.heightMultiplier * 2.9)),
        centerTitle: true,
      ),
      body:Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            children: [
              SizedBox(height: SizeConfig.heightMultiplier * 15,),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: _uploadBloc.file == null ? AssetImage(Strings.getProfilePhotoPlaceholderPath) : FileImage(_uploadBloc.file),
                    backgroundColor: Colors.white,
                    radius: MediaQuery.of(context).size.width / 4.5,
                  ),
                  Positioned(
                      bottom: SizeConfig.heightMultiplier *2,
                      right: SizeConfig.heightMultiplier *2 ,
                      child:  InkWell(
                        onTap:() => selectImage(context),
                        child: Container(
                          padding: EdgeInsets.all(SizeConfig.heightMultiplier / 2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier)
                          ),
                          child: Icon(Icons.add_a_photo,color: AppTheme.primaryColor,),
                        ),
                      )

                  )
                ],//,onPressed:() => selectImage(context),
              ),
              Spacer(),
              InkWell(
                onTap: isFileExist ?  () async{
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
                      CustomFlushBar.customFlushBar(message: "Profile photo updated", type: FlushBarType.INFO);
                    } else {
                      CustomFlushBar.customFlushBar(message: "Upload Failed !", type: FlushBarType.FAILURE);
                    }
                    _uploadBloc.isfileExistSink(false);
                  });
                } : null,
                child: isFileExist ? Shimmer.fromColors(child: Row(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    Text(
                      "Save & Contiue ",
                      style: AppTheme.lightTextTheme.headline6.copyWith(color: isFileExist ? AppTheme.primaryColor : AppTheme.accentColor,fontFamily: Constants.getFreightSansFamily),
                    ),
                    Icon(Icons.arrow_forward,color: isFileExist ? AppTheme.primaryColor : AppTheme.accentColor,),
                    SizedBox(width: SizeConfig.heightMultiplier * 2.5,)
                  ],
                ), baseColor: AppTheme.primaryColor, highlightColor: Colors.white) : SizedBox.shrink(),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 7),
            ],
          )
        ],
      ),
    );
  }

}
