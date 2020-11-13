import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/blocs/upload_bloc.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/utils.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class UploadPostScreen extends StatelessWidget {
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

  Container buildSplashScreen(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//            SvgPicture.asset('assets/images/upload.svg', height: 260.0),
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
    );
  }

  Scaffold buildUploadForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (){
              _uploadBloc.clearPostDetails();
            }),
        title: Text(
          "Caption Post",
          style: AppTheme.lightTextTheme.headline6,
        ),
        actions: [
          StreamBuilder<LoadingState>(
            stream: _uploadBloc.postbuttonStateStream,
            initialData: LoadingState.NORMAL,
            builder: (context, snapshot) {
              final enable = snapshot.data == LoadingState.NORMAL;
              return FlatButton(
                onPressed: enable ?  () {
                  final hasCaption = _captionController.value.text.isNotEmpty;
                  if(!_uploadBloc.isSectionSelected()){
                    DialogPopUps.showCommonDialog(text: "Please select section to Post",ok: () => Navigator.pop(context),context: context);
                    return;
                  }
                  if(!_uploadBloc.isBranchSelected()){
                    DialogPopUps.showCommonDialog(text: "Please select branch to Post",ok: () => Navigator.pop(context),context: context);
                    return;
                  }
                  if(!hasCaption){
                    DialogPopUps.showCommonDialog(text: "Please add a caption",ok: () => Navigator.pop(context),context: context);
                    return;
                  }
                  _uploadBloc.uploadPost(_captionController.value.text,_authBloc.getCurrentUser);
                  _captionController.clear();
                } : null,
                child: Text(
                  "Post",
                  style: AppTheme.lightTextTheme.headline6.copyWith(color: Colors.blueAccent),
                ),
              );
            }
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          children: <Widget>[
            StreamBuilder<LoadingState>(
                stream: _uploadBloc.postbuttonStateStream,
                initialData: LoadingState.NORMAL,
                builder: (context, snapshot) {
                  final state = snapshot.data == LoadingState.LOADING ;
                  return state
                      ? LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    backgroundColor: Colors.white,)
                      : SizedBox.shrink();
                }
            ),
            Container(
              height: 220.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
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
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Form(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: CircleAvatar(
                        child: Text(_authBloc.getCurrentUser.firstname[0]),
                      ),
                      title: Container(
                        width: 250.0,
                        child: TextFormField(
                          controller: _captionController,
                          decoration: InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    StreamBuilder<String>(
                      stream: _uploadBloc.sectionDropdownStream,
                      initialData: Strings.getSelectSection,
                      builder: (context, snapshot) {

                      final sections  = _authBloc.getCurrentUser.classes
                          .map<DropdownMenuItem<String>>((ClassModel value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name),
                          );
                        }).toList();
                        final hint = snapshot.data;
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
                          child: DropdownButton<String>(
                            value: _uploadBloc.selectedSection,
                            hint: Text(hint),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: AppTheme.primaryColor),

                            onChanged: (String newValue) {
                              _uploadBloc.sectionModified(newValue);
                            },
                            items:sections,
                          ),
                        );
                      }
                    ),
                    StreamBuilder<String>(
                        stream: _uploadBloc.branchDropdownStream,
                        initialData: Strings.getSelectBranch,
                        builder: (context, snapshot) {

                          final branches  = _authBloc.getCurrentUser.classes
                              .map<DropdownMenuItem<String>>((ClassModel value) {
                            return DropdownMenuItem<String>(
                              value: value.branch,
                              child: Text(value.branch),
                            );
                          }).toList();
                          final hint = snapshot.data;
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
                            child: DropdownButton<String>(
                              value: _uploadBloc.selectedBranch,
                              hint: Text(hint),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: AppTheme.primaryColor),

                              onChanged: (String newValue) {
                                _uploadBloc.branchModified(newValue);
                              },
                              items:branches,
                            ),
                          );
                        }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

