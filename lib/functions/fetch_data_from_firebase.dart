import 'package:cloud_firestore/cloud_firestore.dart';

class FetchDataFromFirebase {
  final String collection;
  final String doc;
  final String fieldToFetch;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  FetchDataFromFirebase({
    required this.collection,
    required this.doc,
    required this.fieldToFetch,
  });

  Future<dynamic> fetchOneField() async {
    final data = firestore.collection(collection).doc(doc);
    return await data.get().then(
          (DocumentSnapshot document) => document.get(fieldToFetch),
        );
  }
}
