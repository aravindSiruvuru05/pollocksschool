const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


// when a post is created, add post to timeline of each follower (of post owner)
exports.onCreatePost = functions.firestore
  .document("/post/{userId}/userPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postCreated = snapshot.data();
    const userId = context.params.userId; // 223344
    const postId = context.params.postId; // intilli3A

    // 2) Add new post to each classposts timeline
    var str = postId;
    var index = str.indexOf('_');
    var [classId, second] = [str.slice(0, index), str.slice(index + 1)];
    admin
        .firestore()
        .collection("timeline")
        .doc(classId)
        .collection("classPosts")
        .doc(postId)
         .set(postCreated);
  });


exports.onUpdatePost = functions.firestore
  .document("/post/{userId}/userPosts/{postId}")
  .onUpdate(async (change, context) => {
    const postUpdated = change.after.data();
    const userId = context.params.userId;
    const postId = context.params.postId;

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
          if (doc.exists &&  JSON.stringify(postUpdated.likes) !== JSON.stringify(doc.data().likes) ) {
          functions.logger.log("======updated", postUpdated.likes);
          functions.logger.log("======timeline doc", doc.data().likes);
          functions.logger.log("======",JSON.stringify(postUpdated.likes) !== JSON.stringify(doc.data().likes));

            doc.ref.update(postUpdated);
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
          if (doc.exists &&  JSON.stringify(postUpdated.likes) !== JSON.stringify(doc.data().likes)) {
              functions.logger.log("======updated", postUpdated.likes);
              functions.logger.log("======timeline doc", doc.data().likes);
              functions.logger.log("======",JSON.stringify(postUpdated.likes) !== JSON.stringify(doc.data().likes));
            doc.ref.update(postUpdated);
          }
        });
    });



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
    });
