import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  CollectionReference? collectionReference;

  connectCollection() async {
    collectionReference = fireStore.collection('notes');
  }

  Future<void> addNotes(
      {required String title,
      required String subtitle,
      required String date,
      required String time}) async {
    connectCollection();

    String nId = DateTime.now().millisecondsSinceEpoch.toString();

    await collectionReference!
        .doc(nId)
        .set({
          'id': nId,
          'title': title,
          'subtitle': subtitle,
          'time': time,
          'date': date,
        })
        .then(
          (value) => print("Notes is add...."),
        )
        .catchError((error) => print("$error"));
  }

  removeNotes({required String id}) {
    connectCollection();

    collectionReference!
        .doc(id)
        .delete()
        .then((value) => print("Notes delete"))
        .catchError((error) => print("Notes not delete"));
  }

  editNotes({required String id, required Map<Object, Object> data}) {
    connectCollection();

    collectionReference!
        .doc(id)
        .update(data)
        .then((value) => print("Notes Edit"))
        .catchError(
          (error) =>
              print("====================\n$error\n======================"),
        );
  }

  Stream<QuerySnapshot<Object?>> getNotes() {
    connectCollection();

    return collectionReference!.snapshots();
  }
}
