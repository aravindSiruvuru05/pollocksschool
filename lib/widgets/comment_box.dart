
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../enums/enums.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../screens/timeline_screen.dart';
import '../utils/config/size_config.dart';
import '../utils/config/styling.dart';
import 'custom_flush_bar.dart';

class CommentBox extends StatefulWidget {
  CommentBox({
    Key key,
    @required this.commentsRef,
    @required this.post,
    @required this.currentUser,
  }) : super(key: key);

  final CollectionReference commentsRef;
  final PostModel post;
  final UserModel currentUser;

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController controller = TextEditingController();
  CollectionReference activityFeedRef = FirebaseFirestore.instance.collection("feed");

  bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: SizeConfig.heightMultiplier),
      leading: CircleAvatar(
        child: Text(widget.currentUser.firstname[0 ]),),
      title: TextField(
        controller: controller,
        onChanged: (val){
          if(val.length > 0) {
            setState(() {
              isEnabled = true;
            });
          } else {
            setState(() {
              isEnabled = false;
            });
          }
        },
        decoration: InputDecoration(
            hintText: 'Add Comment'
        ),
      ),
      trailing: IconButton(
          icon: isEnabled ? Icon(Icons.check,color: AppTheme.primaryColor,size: 25,) : Icon(Icons.check,color: Colors.blueGrey,size: 25,),
          onPressed: !isEnabled ? null : () async{
            final commnetId = Uuid().v4();
            FocusScope.of(context).requestFocus(new FocusNode());
            if(controller.text.isEmpty){
              return;
            }
            setState(() {
              isEnabled = false;
            });
            await widget.commentsRef
                .doc(widget.post.postId)
                .collection('comments')
                .doc(commnetId)
                .set({
              "id": commnetId,
              "username" : "${widget.currentUser.firstname} ${widget.currentUser.lastname}",
              "comment" : controller.text,
              "timestamp": DateTime.now(),
              "avatarUrl": widget.currentUser.photourl,
              "userId": widget.currentUser.id,
              "postownerId": widget.post.ownerId,
            }).then((value) {
              controller.clear();
              CustomFlushBar.customFlushBar(message: "comment added successfully ", scaffoldKey: timelineScaffoldKey,type: FlushBarType.SUCCESS);
              bool isNotPostOwner = widget.post.ownerId != widget.currentUser.id;
              if (isNotPostOwner) {
                activityFeedRef.doc(widget.post.ownerId).collection('feedItems').add({
                  "type": "comment",
                  "commentData": controller.text,
                  "timestamp": DateTime.now(),
                  "postId": widget.post.postId,
                  "userId": widget.currentUser.id,
                  "username": "${widget.currentUser.firstname} ${widget.currentUser.lastname}",
                  "userProfileImg": widget.currentUser.photourl,
                  "mediaUrl": widget.post.mediaUrl,
                });
              }
            },onError: (error) {
              controller.clear();
              CustomFlushBar.customFlushBar(message: "error adding comment ! ", scaffoldKey: postDetailScaffoldKey,type: FlushBarType.FAILURE);
            });
          }
      ),
    );
  }
}