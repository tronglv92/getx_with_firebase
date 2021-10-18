const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();
const auth = admin.auth();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.log("request body ", request.body, { structuredData: true });
  functions.logger.log("request query ", request.query, {
    structuredData: true,
  });
  response.send("Hello from Firebase!");
});

// http request get user

exports.getUser = functions.https.onRequest(async (req, res) => {
  const userId = req.query.userId;
  functions.logger.log("request userId ", userId, { structuredData: true });
  const query = await database.doc(`users/${userId}`).get();

  const data = query.data();

  // res.send(JSON.stringify(data));
  res.send({ email: data.email });
});

// exports.getAllUsers = functions.https.onRequest(async (req, res) => {
//   const userId = req.query.userId;
//   functions.logger.log("request userId ", userId, { structuredData: true });
//   const query = await database.collection(`users`).get();
//   let users = [];
//   query.docs.map((doc) => {
//     users.push(doc.data());
//   });
//   let result = { users: users };
//   // res.send(JSON.stringify(data));
//   res.send(JSON.stringify(result));
// });

exports.sayHello = functions.https.onCall((data, context) => {
  return `hello, ninjas`;


});



// IMPORTANT

// exports.newUserSignup = functions.auth.user().onCreate((user) => {
//   return admin.firestore().collection("users").doc(user.uid).set({
//     email: user.email,
//     displayName: user.displayName,
//     phoneNumber: user.phoneNumber,
//     photoURL: user.photoURL,
//     uid:user.uid,
//     roleId: 0,
//   });
// });

exports.userDeleted = functions.auth.user().onDelete((user) => {
  const doc = database.collection("users").doc(user.uid);
  return doc.delete();
});

// http callable function
exports.sayHello = functions.https.onCall((data, context) => {
  functions.logger.log("sayHello data ", data, { structuredData: true });
  const name = data.name;
  return `hello, ${name}`;
});
exports.getAllUsers=functions.https.onCall((data,context)=>{
  if(!context.auth)
  {
    throw new functions.https.HttpsError('unauthenticated','only authenticated users can get all users');
  }
  
})