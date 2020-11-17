import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/enums/activity_type.dart';
import 'package:pollocksschool/models/activity_model.dart';
import 'package:provider/provider.dart';
import '../blocs/blocs.dart';
import '../enums/enums.dart';
import '../utils/config/size_config.dart';
import '../utils/config/styling.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;


// ignore: must_be_immutable
class ActivityScreen extends StatelessWidget {
  CollectionReference activityRef;

  @override
  Widget build(BuildContext context) {
    activityRef = FirebaseFirestore.instance.collection("feed");
    ActivityBloc activityBloc = Provider.of<ActivityBloc>(context);
    final docId = activityBloc.currentUser.userType == UserType.STUDENT
        ? activityBloc.currentUser.classIds[0]
        : activityBloc.currentUser.id;
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Feed", style: AppTheme.lightTextTheme.headline6.copyWith(fontFamily: Constants.getHelveticaNeueFamily,
            color: AppTheme.primaryColor,fontWeight: FontWeight.bold,letterSpacing: 1.5,fontSize: SizeConfig.heightMultiplier * 2.9)),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: activityRef.doc(docId).collection('feedItems')
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

                final List<ActivityModel> finalComments = comments.docs.map((
                    doc) => ActivityModel.fromDocument(doc)).toList();
                final List<Widget> commentBlocks = finalComments.map<Widget>((e) =>
                    buildCommentTile(e)).toList();
                return Column(
                    children: commentBlocks
                );
              }
            }
        ),

      ),
    );
  }

  Widget buildCommentTile(ActivityModel activityModel) {
    final timeText = Text('${timeago.format(activityModel.timestamp.toDate())}',
        style: AppTheme.lightTextTheme.subtitle2.copyWith(color: Colors.blue)
    );
    return InkWell(
      onTap: () => print('d'),
      child: CommonShadowCard(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(activityModel.username[0]),),
          title: RichText(
            text: TextSpan(
                text: "",
                children: <TextSpan>[
                  TextSpan(text:activityModel.username,
                      style: AppTheme.lightTextTheme.button
                          .copyWith(fontFamily: Constants.getFreightSansFamily)),
                  TextSpan(text: " "),
                  TextSpan(text: getCenterText(activityModel.type),style: AppTheme.lightTextTheme.subtitle2.copyWith(color: Colors.black87)),
                ]
            ),
          ),
          subtitle: activityModel.type == ActivityType.LIKE ? timeText :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${activityModel.caption}',maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,style: AppTheme.lightTextTheme.bodyText2.copyWith(color: AppTheme.primaryColor.withOpacity(0.7)),
              ),
              timeText,
            ],
          ) ,
          trailing: Image.network(activityModel.mediaUrl),
        ),
      ),
    );
  }

  getCenterText(ActivityType type) {
    switch(type){
      case ActivityType.LIKE:{
        return "liked your post";
      }break;
      case ActivityType.COMMENT:{
        return "commented on your post";
      }break;
      default:{
        return "posted";
      }break;
    }
  }
}
