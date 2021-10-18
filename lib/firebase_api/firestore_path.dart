/*
This class defines all the possible read/write locations from the FirebaseFirestore database.
In future, any new path can be added here.
This class work together with FirestoreService and FirestoreDatabase.
 */

// ignore: avoid_classes_with_only_static_members
class FireStorePath {
  static String todo(String uid, String todoId) => 'users/$uid/todos/$todoId';
  static String todos(String uid) => 'users/$uid/todos';

  static String user(String uid) => 'users/$uid';
  static String fcmToken(String uid) => 'fcmTokens/$uid';

  static String users() => 'users';
  static String products() => 'products';
}
