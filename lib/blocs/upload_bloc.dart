import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UploadBloc extends Bloc {
  File file;
  String dropdownValue;
  String _caption;
  ImagePicker _imagePicker;
  String rand_id;
  StorageReference _storageRef;
  CollectionReference _postCollectionRef;
  CollectionReference _userCollectionRef;
  CollectionReference _activityFeedRef;

  UserModel _currentUser;

  ImagePicker get imagePicker => _imagePicker;

  // login button --------------
  final _postbuttonState = StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get postbuttonStateStream => _postbuttonState.stream;
  Function get postbuttonStateSink => _postbuttonState.sink.add;

  final _sectionDropdownController = StreamController<String>.broadcast();
  Stream<String> get sectionDropdownStream => _sectionDropdownController.stream;
  Function get _sectionDropdownSink => _sectionDropdownController.sink.add;

  final _branchDropdownController = StreamController<String>.broadcast();
  Stream<String> get branchDropdownStream => _branchDropdownController.stream;
  Function get _branchDropdownSink => _branchDropdownController.sink.add;

  final _isfileExistStream = StreamController<bool>.broadcast();
  Stream<bool> get isfileExist => _isfileExistStream.stream;
  Function get isfileExistSink => _isfileExistStream.sink.add;

  String _selectedSection;

  String get selectedSection => _selectedSection;

  String _selectedBranch;

  String get selectedBranch => _selectedBranch;

  UploadBloc() {
    _storageRef = FirebaseStorage.instance.ref();
    _activityFeedRef = FirebaseFirestore.instance.collection("feed");
    _userCollectionRef = FirebaseFirestore.instance.collection("user");
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
    _imagePicker = ImagePicker();
    rand_id = Uuid().v4();
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$rand_id.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    file = compressedImageFile;
  }

  Future<String> uploadImage(String id) async {
    StorageUploadTask uploadTask =
        _storageRef.child(id).putFile(file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  sectionModified(String section) {
    _sectionDropdownSink(section);
    _selectedSection = section;
  }

  branchModified(String branch) {
    _branchDropdownSink(branch);
    _selectedBranch = branch;
  }

   Future<bool> uploadPost(String caption, UserModel curentUser) async{
    bool isUploaded = false;
    _caption = caption;
    _currentUser = curentUser;
    postbuttonStateSink(LoadingState.LOADING);
    await compressImage();
    String mediaUrl = await uploadImage("post_$rand_id.jpg");
    isUploaded = await createPostInFirestore(mediaUrl);
    if(isUploaded) await addFeed(mediaUrl);
    postbuttonStateSink(LoadingState.DONE);
    file = null;
    rand_id = Uuid().v4();
    //retun true if file uploaded and removed ref
    return file == null && isUploaded;
  }


  Future<bool> uploadProfilePhoto(UserModel user) async{
    bool isUploaded = false;
    _currentUser = user;
//    postbuttonStateSink(LoadingState.LOADING);
    await compressImage();
    String mediaUrl = await uploadImage("profile_photo_$rand_id.jpg");
    print(mediaUrl);
    isUploaded = await createProfilePhotoInFirestore(mediaUrl);
//    postbuttonStateSink(LoadingState.DONE);
    file = null;
    rand_id = Uuid().v4();
    //retun true if file uploaded and removed ref
    return file == null && isUploaded;
  }



  Future<void> addFeed(String mediaUrl) async {
    final docId = '$_selectedBranch$_selectedSection';
    final id = "$_selectedBranch${_selectedSection}_$rand_id";
    await _activityFeedRef.doc(docId).collection('feedItems').add({
      "type": "post",
      "caption": _caption,
      "timestamp": DateTime.now(),
      "postId": id,
      "userId": _currentUser.id,
      "username": "${_currentUser.firstname} ${_currentUser.lastname}",
      "userProfileImg": _currentUser.photourl,
      "mediaUrl": mediaUrl,
    });
    print(id);
  }

  // ignore: missing_return
  Future<bool> createProfilePhotoInFirestore(String mediaUrl) async{
    bool isSuccess = false;
   await _userCollectionRef.doc(_currentUser.id).update({
      'photourl' : mediaUrl
    }).then((value) => isSuccess = true)
      .catchError((onError) => isSuccess= false);
   print(isSuccess);
    return isSuccess;

  }

  Future<bool> createPostInFirestore(String mediaUrl) async{
    bool isSuccess = false;
    final id = "$_selectedBranch${_selectedSection}_$rand_id";
    final classId = "$_selectedBranch$_selectedSection";
    await _postCollectionRef.doc(_currentUser.id).collection("userPosts").doc(id).set({
      "postId": id,
      "ownerId": _currentUser.id,
      "ownerProfileImgUrl": _currentUser.photourl,
      "ownerType": describeEnum(_currentUser.userType),
      "username": "${_currentUser.firstname} ${_currentUser.lastname}",
      "mediaUrl": mediaUrl,
      "description": _caption,
      "classId": classId,
      "timestamp": DateTime.now(),
      "commentsCount": 0,
      "likes": {}
    }).then((value) => isSuccess = true)
        .catchError((onError) => isSuccess= false);
    print(isSuccess);
    return isSuccess;

  }

  handleTakePhoto() async {
    try {
      PickedFile file = await _imagePicker.getImage(
        source: ImageSource.camera,
        maxHeight: 675,
        maxWidth: 960,
      );
      this.file = File(file.path);
      toggleUploadPage();
    } catch (e) {
      print(e);
    }
  }

  handleChooseFromGallery() async {
    try {
      PickedFile file =
          await _imagePicker.getImage(source: ImageSource.gallery);
      this.file = File(file.path);
      toggleUploadPage();
    } catch (e) {
      print(e);
    }
  }

  clearPostDetails() {
    file = null;
    toggleUploadPage();
  }

  toggleUploadPage() {
    final fileExist = file != null;
    isfileExistSink(fileExist);
  }

  bool isSectionSelected() {
    return _selectedSection != null &&
        _selectedSection != Strings.getSelectSection;
  }

  bool isBranchSelected() {
    return _selectedBranch != null &&
        _selectedBranch != Strings.getSelectBranch;
  }

  @override
  void dispose() {
    _isfileExistStream.close();
    _postbuttonState.close();
    _sectionDropdownController.close();
    _branchDropdownController.close();
    // TODO: implement dispose
  }
}
