

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/blocs.dart';
import '../enums/enums.dart';
import '../utils/config/size_config.dart';
import '../utils/config/styling.dart';
import '../utils/constants.dart';

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
            stream:  activityRef.doc(docId).collection('feedItems')
                .orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              print("d");
                final feedSnap = snapshot.data;
                if(snapshot.data == null) {
                  return Text('Loading');
                } else if(feedSnap.docs.length == 0) {
                  return Text('No items in feed');
                } else {
                  List<String> a = feedSnap.docs.map((element) {
                   return element.data()['postId'] as String;
                  }).toList();
                  return ListView(
                    children: a.map((e) => Text(e)).toList(),
                  );
                }
              }
        ),
      ),
    );
  }
}
