import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseProblemSet {
  late FirebaseFirestore firestore;
  problemSetIntialized() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(String problems, String age) async {
    try {
      await firestore.collection("ProblemSet").add({
        'problems': problems,
        'age': age,
        'timestamp':
            FieldValue.serverTimestamp() //this is to get the server timeStamp
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("ProblemSet").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('ProblemSet').orderBy('timestamp').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "age": doc['age'],
            "problems": doc['problems']
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

  Future<void> update(String id, String age, String problems) async {
    try {
      await firestore
          .collection("ProblemSet")
          .doc(id)
          .update({'age': age, 'problems': problems});
    } catch (e) {
      print(e);
    }
  }
}
