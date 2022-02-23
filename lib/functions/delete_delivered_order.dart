import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteDeliveredOrder {
  final String collection;
  final String? secondCollection;
  final String doc;
  final String? secondDoc;

  DeleteDeliveredOrder({
    required this.collection,
    this.secondCollection,
    required this.doc,
    this.secondDoc,
  });

  void deleteOrder() {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(doc)
        .collection(secondCollection!)
        .doc(secondDoc!)
        .delete();
  }

  void deleteOrderWhenOrderCanceled() {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(doc)
        .delete();
  }
}
