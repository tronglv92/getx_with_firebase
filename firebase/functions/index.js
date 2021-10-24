const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Client } = require("@elastic/elasticsearch");

const env = functions.config();
admin.initializeApp();
const database = admin.firestore();
const auth = {
  username: env.elasticsearch.username,
  password: env.elasticsearch.password,
};

const client = new Client({ node: env.elasticsearch.url, auth: auth });
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
const FCM_TOKENS = "fcmTokens";
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

exports.getAllUsers = functions.https.onRequest(async (req, res) => {
  const userId = req.query.userId;
  functions.logger.log("request userId ", userId, { structuredData: true });
  const query = await database.collection(`users`).get();
  let users = [];
  query.docs.map((doc) => {
    users.push(doc.data());
  });
  let result = { users: users };
  // res.send(JSON.stringify(data));
  res.send(JSON.stringify(result));
});

exports.sayHello = functions.https.onCall((data, context) => {
  return `hello, ninjas`;
});

// IMPORTANT

exports.newUserSignup = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection("users").doc(user.uid).set({
    email: user.email,
    displayName: user.displayName,
    phoneNumber: user.phoneNumber,
    photoURL: user.photoURL,
    uid:user.uid,
    roleId: 0,
  });
});

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
exports.sendNotifications = functions.https.onCall(async (data, context) => {

  let uid = data.uid;
  let message=data.message;
  let title=data.title;

  console.log("uid ", uid);
  if (uid == null) {
    throw new functions.https.HttpsError("invalid-argument", "missing uid");
  }
  if (!context.auth) {
    functions.logger.log("unauthenticated ", data, { structuredData: true });
    throw new functions.https.HttpsError(
      "unauthenticated",
      "only authenticated users can get all users"
    );
  }
  sendNotificationToUid(uid,message,title);

  return console.log("end of sendNotifications");
});

async function sendNotificationToUid(uid,title,message) {
  let path=FCM_TOKENS+'/'+uid+'/tokens';
  console.log("path ", path);
  let collection = await database.collection(path).get();

  let docs = collection.docs;

   docs.map((item)=>{
    let data= item.data()
    if(data!=undefined)
    {
      let fcmToken = data.fcmToken;
      console.log("fcmToken ", fcmToken);
      sendNotification(uid,fcmToken,title,message);
    }

   })

}

// exports.sheduleNotification=functions.pubsub.schedule('* * * * *').onRun( async(context)=>{

//   console.log("sheduleNotification");
//   let now=admin.firestore.Timestamp.now();
//   const query=await database.collection('notifications').where('notificationSend','==',false).where('whenToNotify','<=',now).get();

//   query.forEach(async snapshot=>{

//     let id=snapshot.id;
//     let uid=snapshot.data().uid;
//     let title=snapshot.data().title;
//     let message=snapshot.data().message;
//     console.log("id: ",id);
//     console.log("uid: ",uid);
//     await sendNotificationToUid(uid,title,message);

//     await database.doc('notifications/'+snapshot.id).update({
//       'notificationSend':true
//     });

//   })

// })
exports.scheduleNotification= functions.https.onCall(async (data, context) => {
  let now=admin.firestore.Timestamp.now();
  const query=await database.collection('notifications').where('notificationSend','==',false).where('whenToNotify','<=',now).get();

  query.forEach(async snapshot=>{

    let id=snapshot.id;
    let uid=snapshot.data().uid;
    let title=snapshot.data().title;
    let message=snapshot.data().message;
    console.log("id: ",id);
    console.log("uid: ",uid);
    await sendNotificationToUid(uid,title,message);

    await database.doc('notifications/'+snapshot.id).update({
      'notificationSend':true
    });

  })
});
function sendNotification(uid,fcmToken,title,body) {
  const message = {

    token: fcmToken,
    data: { click_action: "FLUTTER_NOTIFICATION_CLICK", title: title, body: body},
  };
  admin
    .messaging()
    .send(message)
    .then((response) => {
      return console.log("Successfull Message Sent");
    })
    .catch((error) => {

      if(error.errorInfo && error.errorInfo.code=='messaging/invalid-argument')
      {
        removeFcmToken(uid,fcmToken);
      }
      else if(error.errorInfo && error.errorInfo.code=='messaging/registration-token-not-registered')
      {
        removeFcmToken(uid,fcmToken);
      }
      else
      {
        console.log('sendNotification error ',error);

      }
      return ;
    });
}

async function removeFcmToken(uid,fcmToken) {
  let path=FCM_TOKENS+'/'+uid+'/tokens/'+fcmToken;
  console.log("path ", path);
  database.doc(path).delete();
}
function deleteCollection(path) {
  database.collection(path).listDocuments().then(val => {
      val.map((val) => {
          val.delete()
      })
  })
}

// ELASTIC SEARCH

exports.indexAllProducts = functions.https.onRequest(async (req, res) => {
  

  const data = query.docs.map(async (doc) => {
    let body = doc.data();
    let id=doc.id;
    console.log("body ",body);
    console.log("id ",id)
    await client.index({
      index: "products",
      type: "_doc",
      id: id,
      body: body,
    });

  
  });
  
  // res.send(JSON.stringify(data));
  res.send("indexAllProducts success");
});



exports.createProduct = functions.firestore
  .document("products/{docId}")
  .onCreate(async (snap, context) => {
    await client.index({
      index: "products",
      type: "_doc",
      id: snap.id,
      body: snap.data(),
    });
  });
exports.updateProduct = functions.firestore
  .document("products/{ProductId}")
  .onUpdate(async (snap, context) => {
    await client.index({
      index: "products",
      type: "_doc",
      id: snap.id,
      body: snap.after.data(),
    });
  });
exports.deleteProduct = functions.firestore
  .document("products/{ProductId}")
  .onDelete(async (snap, context) => {
    await client.delete({
      index: "products",
      type: "_doc",
      id: snap.id,
    });
  });
  
  exports.searchProduct= functions.https.onCall(async (data, context) => {
    if (!context.auth) {
      
      throw new functions.https.HttpsError(
        "unauthenticated",
        "only authenticated users can get all users"
      );
    }
    console.log("vao trong searchProduct ");
    let search=data.search;
    console.log("searchProduct search ",search);
    const { body } = await client.search({
      index: 'products',
      // type: '_doc', // uncomment this line if you are using Elasticsearch ≤ 6
      body: {
        query: {
          match_phrase_prefix: { name: search }
        }
      }
    })
    let products=[];
    products=body.hits.hits.map((item)=> item._source)
    
    console.log(products)
    return products;
  });