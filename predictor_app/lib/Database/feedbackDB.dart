import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFeedBack {
  late FirebaseFirestore firestore;
  feedBackIntialized() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(String userUid, String username, String email, String age,
      String comment) async {
    try {
      await firestore.collection("Feedback").add({
        'username': username,
        'userUid': userUid,
        'email': email,
        'age': age,
        'comment': comment,
        'timestamp':
            FieldValue.serverTimestamp() //this is to get the server timeStamp
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("Feedback").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('Feedback').orderBy('timestamp').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "userUid": doc['userUid'],
            "username": doc['username'],
            "email": doc['email'],
            "age": doc['age'],
            "comment": doc['comment']
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      // print(e);
    }
    return [];
  }

  Future<void> update(String id, String username, String email, String age,
      String comment) async {
    try {
      await firestore
          .collection("Feedback")
          .doc(id)
          .update({'comment': comment});
    } catch (e) {
      print(e);
    }
  }
}
