import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String postId;
  StorageReference _storageRef;
  CollectionReference _postCollectionRef;

  UserModel _user;


  ImagePicker get imagePicker => _imagePicker;

  // login button --------------
  final _postbuttonState =
  StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get postbuttonStateStream =>
      _postbuttonState.stream;
  Function get postbuttonStateSink => _postbuttonState.sink.add;

  final _dropdownController =
  StreamController<String>.broadcast();
  Stream<String> get dropdownStream =>
      _dropdownController.stream;
  Function get _dropdownSink => _dropdownController.sink.add;

  final _isfileExistStream =
  StreamController<bool>.broadcast();
  Stream<bool> get isfileExist =>
      _isfileExistStream.stream;
  Function get isfileExistSink => _isfileExistStream.sink.add;

  String _selectedSection;

  String get selectedSection => _selectedSection;

  UploadBloc(){
    _storageRef = FirebaseStorage.instance.ref();
    _postCollectionRef = FirebaseFirestore.instance.collection("post");
    _imagePicker = ImagePicker();
    postId = Uuid().v4();
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    file = compressedImageFile;
  }

  Future<String> uploadImage() async {
    StorageUploadTask uploadTask =
    _storageRef.child("post_$postId.jpg").putFile(file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  sectionModified(String section){
    _dropdownSink(section);
    _selectedSection = section;
  }

   uploadPost(String caption, UserModel user) async{
    _caption = caption;
    _user = user;
    postbuttonStateSink(LoadingState.LOADING);
    await compressImage();
    String mediaUrl = await uploadImage();
    await createPostInFirestore(mediaUrl);
    caption = null;
    postbuttonStateSink(LoadingState.DONE);
    file = null;
    final fileExist = file != null;
    postId = Uuid().v4();
    Timer(Duration(milliseconds: 500),(){
      isfileExistSink(fileExist);
    });
  }


  // ignore: missing_return
  Future<void> createPostInFirestore(String mediaUrl) {
    _postCollectionRef.doc(_user.id)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": _user.id,
      "username": "${_user.firstname} ${_user.lastname}",
      "mediaUrl": mediaUrl,
      "description": _caption,
      "timestamp": DateTime.now(),
      "likes": {}
    });
  }

  handleTakePhoto() async {
    PickedFile file = await _imagePicker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    this.file = File(file.path);
    toggleUploadPage();
  }

  handleChooseFromGallery() async {
    PickedFile file = await _imagePicker.getImage(source: ImageSource.gallery);
    this.file = File(file.path);
    toggleUploadPage();
  }

  clearPostDetails(){
    file = null;
    toggleUploadPage();
  }

  toggleUploadPage(){
    final fileExist = file != null ;
    isfileExistSink(fileExist);
  }

  bool isSectionSelected(){
    return _selectedSection != null && _selectedSection != Strings.getSelectSection;
  }

  @override
  void dispose() {
    _isfileExistStream.close();
    _postbuttonState.close();
    _dropdownController.close();
    // TODO: implement dispose
  }


}