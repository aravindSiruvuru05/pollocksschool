import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../utils/config/size_config.dart';
import '../utils/config/styling.dart';


// ignore: must_be_immutable
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShadowCard(child: buildPostDetailCard()),
                StreamBuilder<QuerySnapshot>(
                  stream:  commentsRef.doc(post.postId).collection('comments')
                      .orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    final comments = snapshot.data;

                    print(comments);
                    if (comments == null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SpinKitThreeBounce(
                          color: AppTheme.primaryColor,
                          size: SizeConfig.heightMultiplier * 3,
                        ),
                      );
                    } else {
                      print(comments.docs.length);

                      final List<CommentModel> finalComments = comments.docs.map((
                          doc) => CommentModel.fromDocument(doc)).toList();
                      final List<Widget> commentBlocks = finalComments.map<Widget>((e) =>
                          CommonShadowCard(child: buildCommentTile(e))).toList();
                      return Column(
                        children: [
                          CommonShadowCard(child: buildCountContainer(finalComments.length)),
                          CommonShadowCard(child: CommentBox(
                              commentsRef: commentsRef,
                              post: post, currentUser: currentUser)
                          ),
                          Column(
                              children: commentBlocks
                          ),
                        ],
                      );
                    }
                  }
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 4,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCommentTile(CommentModel comment) {
    return ListTile(
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
      trailing: currentUser.id == comment.userid
          ?  PopupMenuButton<String>(
        onSelected: (value) async{
          if (value == Constants.getDeleteString) {
            await commentsRef
                .doc(post.postId)
                .collection('comments')
                .doc(comment.id)
                .get().then((value) => value.reference.delete());
          }
        },
        icon: Icon(
          Icons.more_vert,
          color: AppTheme.accentColor,
        ),
        itemBuilder: (BuildContext context) {
          return Constants.getCommentMenuChoices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      )
          : SizedBox.shrink(),

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
                      child: ProfilePhotoIcon(username: post.username,radius: SizeConfig.heightMultiplier * 4,photoUrl: post.ownerProfileImgUrl,)
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

  buildCountContainer(int count) {
    final likes = post.getLikeCount;
    final likeText = likes == 1 ? '' : 's';
    final commnetCount = count == 1 ? '' : 's';
    return  Container(
     padding: EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 2),
     child: Row(
        children: [
          Text("$likes like$likeText",style: AppTheme.lightTextTheme.button.copyWith(color: Colors.red),),
          SizedBox(width: SizeConfig.heightMultiplier * 2,),
          Text("$count comment$commnetCount",style: AppTheme.lightTextTheme.button.copyWith(color: AppTheme.primaryColor),)
        ],
      ),
   );
  }
}


