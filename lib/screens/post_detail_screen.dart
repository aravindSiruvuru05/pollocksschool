import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailScreen extends StatelessWidget {
  final PostModel post;

  bool isLiked;
  UserModel currentUser;

  CollectionReference commentsRef;

  PostDetailScreen({Key key,@required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    currentUser = authBloc.getCurrentUser;
    isLiked = post.likes[currentUser.id] == null ? false : post.likes[currentUser.id];
    commentsRef = FirebaseFirestore.instance.collection("comment");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.appBackgroundColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            color: AppTheme.appBackgroundColor,
            margin: EdgeInsets.only(top: SizeConfig.heightMultiplier),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCommonCard(buildPostDetailCard()),
                buildCommonCard(buildAddCommentTile(context)),
                StreamBuilder<QuerySnapshot>(
                  stream:  commentsRef.doc(post.postId).collection('comments')
                      .orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    final comments = snapshot.data;
                    if (comments == null) {
                      return SizedBox.shrink();
                    } else {
                      final List<CommentModel> finalComments = comments.docs.map((
                          doc) => CommentModel.fromDocument(doc)).toList();
                      final List<Container> commentBlocks = finalComments.map<Container>((e) =>
                          buildCommentTile(e)).toList();

                      return Column(
                          children: commentBlocks
                      );
                    }
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Container buildCommentTile(CommentModel comment) {
    return Container(
      margin: EdgeInsets.only(left: SizeConfig.heightMultiplier * 2.5,
          right: SizeConfig.heightMultiplier * 2.5,top: SizeConfig.heightMultiplier *2),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 1.5,vertical: SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: 15.0,
              offset: Offset(0,0)
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: SizeConfig.heightMultiplier),
        leading: CircleAvatar(
                child: Text(comment.username[0]),),
        title: RichText(
          text: TextSpan(
              text: "",
              children: <TextSpan>[
                TextSpan(text:comment.username,
                  style: AppTheme.lightTextTheme.button
                      .copyWith(fontFamily: Constants.getFreightSansFamily)),
                TextSpan(text: "  "),
                TextSpan(text: timeago.format(comment.timestamp.toDate()),
                    style: AppTheme.lightTextTheme.subtitle2.copyWith(color: Colors.blue)
                )
              ]
          ),
        ),
        subtitle: Text(comment.comment),

      ),
    );
  }
  ListTile buildAddCommentTile(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return ListTile(
      contentPadding: EdgeInsets.only(left: SizeConfig.heightMultiplier),
      leading: CircleAvatar(
              child: Text("A"),),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: 'Add Comment'
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.check,color: Colors.blue,size: 25,),
        onPressed: () async{
          FocusScope.of(context).requestFocus(new FocusNode());
          if(controller.text.isEmpty){
            return;
          }
          await commentsRef
              .doc(post.postId)
              .collection('comments')
              .add({
            "username" : "${currentUser.firstname} ${currentUser.lastname}",
            "comment" : controller.text,
            "timestamp": DateTime.now(),
            "avatarurl": currentUser.photourl,
            "userid": currentUser.id,
            "postownerid": post.ownerId
          });
          controller.clear();
        }
      ),
    );
  }



  buildCommonCard(Widget child) {
    return Container(
      margin: EdgeInsets.only(left: SizeConfig.heightMultiplier * 2.5,
          right: SizeConfig.heightMultiplier * 2.5,top: SizeConfig.heightMultiplier *2),
      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: 15.0,
              offset: Offset(0,0)
          ),
        ],
      ),
      child: child,
    );
  }

   buildPostDetailCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
                    contentPadding: EdgeInsets.only(left: SizeConfig.heightMultiplier),
                    leading: Hero(
                      tag: post,
                      child: CircleAvatar(
                        radius: SizeConfig.heightMultiplier * 4,
                        backgroundImage: post.mediaUrl != null
                            ? CachedNetworkImageProvider(post.mediaUrl)
                            : null,
                        backgroundColor: Colors.grey,
                        child: post.mediaUrl == null ? Text(post.username[0]) : null,
                      ),
                    ),
                    title: Hero(
                      tag: post.mediaUrl,
                      child: Text(
                        post.username,
                        style: AppTheme.lightTextTheme.button
                            .copyWith(fontFamily: Constants.getFreightSansFamily),
                      ),
                    ),
                    subtitle:  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black, fontSize: SizeConfig.heightMultiplier * 4),
                      children: <TextSpan>[
                        TextSpan(text: 'post from:', style: AppTheme.lightTextTheme.headline6),
                        TextSpan(text: 'Intilli 3A', style: TextStyle(color: Colors.blueAccent))
                      ],
                      ),    textScaleFactor: 0.5,),
                  ),
        Padding(
          padding: EdgeInsets.all(SizeConfig.heightMultiplier),
          child: Text(post.description,style: AppTheme.lightTextTheme.button
              .copyWith(fontFamily: Constants.getHelveticaNeueFamily),),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 2),
          child: Hero(
            tag: post.postId,
            child: CachedNetworkImage(
              imageUrl: post.mediaUrl,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 60,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ],
    );
  }
}