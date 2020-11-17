const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

// when a post is created, add post to timeline of each follower (of post owner)
exports.onCreatePost = functions.firestore
  .document("/post/{userId}/userPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postCreated = snapshot.data();
    const userId = context.params.userId; // 223344
    const postId = context.params.postId; // intilli3A

    // 2) Add new post to each classposts timeline

    const index = postId.indexOf('_');
    var [classId, uuId] = [postId.slice(0, index), postId.slice(index + 1)];
    admin
        .firestore()
            .collection("timeline")
            .doc(classId)
            .collection("classPosts")
            .doc(postId)
             .set(postCreated);


    admin.firestore().collection("user")
                       .where("classIds","array-contains",classId)
                       .where("pushToken",">","")
                       .get()
                       .then((usersWithToken) => {
                         var tokens = [];
                         if(usersWithToken.empty){
                             functions.logger.log("No Devices");
                         }else {
                             for(var token of usersWithToken.docs){
                             functions.logger.log(token.data().pushToken);
                                 tokens.push(token.data().pushToken);
                             }
                             const payload = {
                                           'notification': {
                                               'title': `${postCreated.username} says !!`,
                                               'body': `${postCreated.description}`,
                                               'sound': 'default'
                                           },
                                           'data': {
                                                'sendername': 'sendername',
                                                'message': 'msgg'
                                           }
                                      };
                              return admin.messaging().sendToDevice(tokens,payload).then((res)=> {
                                 functions.logger.log('pushed to all devices');
                              }).catch((err)=>{
                                  functions.logger.log(err);
                              });

                         }
                     });


  });


exports.onUpdateTimelinePost = functions.firestore
  .document("/timeline/{classId}/classPosts/{postId}")
  .onUpdate(async (change, context) => {
    const postUpdated = change.after.data();
    const classId = context.params.classId;
    const postId = context.params.postId;
    admin
        .firestore()
        .collection("post")
        .doc(postUpdated.ownerId)
        .collection("userPosts")
        .doc(postId)
        .get()
        .then(doc => {
          doc.ref.update(postUpdated);
        });
    });

//exports.onUpdatePost = functions.firestore
//  .document("/post/{userId}/userPosts/{postId}")
//  .onUpdate(async (change, context) => {
//    const postUpdated = change.after.data();
//    const userId = context.params.userId;
//    const postId = context.params.postId;
//
//    var str = postId;
//    var index = str.indexOf('_');
//    var [classId, second] = [str.slice(0, index), str.slice(index + 1)];
//
//    admin
//         .firestore()
//         .collection("timeline")
//         .doc("admin")
//         .collection("posts")
//         .doc(postId)
//         .get()
//         .then(doc => {
//             doc.ref.update(postUpdated);
//         });
//    });


exports.onDeletePost = functions.firestore
  .document("/posts/{userId}/userPosts/{postId}")
  .onDelete(async (snapshot, context) => {
  const postUpdated = change.after.data();
    const userId = context.params.userId;
    const postId = context.params.postId;


 // 2) updatin new post to each classposts timeline
    var str = postId;
    var index = str.indexOf('_');
    var [classId, second] = [str.slice(0, index), str.slice(index + 1)];
    admin
        .firestore()
        .collection("timeline")
        .doc(classId)
        .collection("classPosts")
        .doc(postId)
        .get()
        .then(doc => {
          if (doc.exists) {
            doc.ref.delete();
          }
        });
    admin
         .firestore()
         .collection("timeline")
         .doc("admin")
         .collection("posts")
         .doc(postId)
         .get()
         .then(doc => {
            if (doc.exists) {
              doc.ref.delete();
            }
         });
    });


exports.onCreateComment = functions.firestore
  .document("/comment/{postId}/comments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const commentCreated = snapshot.data();
    const postId = context.params.postId;
   const index = postId.indexOf('_');
   var [classId, uuId] = [postId.slice(0, index), postId.slice(index + 1)];
   admin
        .firestore()
        .collection("timeline")
        .doc(classId)
        .collection("classPosts")
        .doc(postId)
        .get()
        .then(doc => {
        const post = doc.data();
        functions.logger.log("=====  =",post.commentsCount);
        const count = post.commentsCount+1;
             doc.ref.update({'commentsCount':count});
        });
  });