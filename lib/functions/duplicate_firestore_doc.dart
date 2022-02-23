import 'package:cloud_firestore/cloud_firestore.dart';

void duplicateFirestoreDoc(
  int orderNumber,
  String employeeDocId,
) async {
  await FirebaseFirestore.instance
      .collection('deliveryManOrders')
      .doc('$orderNumber')
      .get()
      .then(
    (DocumentSnapshot document) async {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('deliveryMans')
          .doc(employeeDocId)
          .collection('orders')
          .doc('$orderNumber')
          .set(data)
          .then(
            (value) => FirebaseFirestore.instance
                .collection('deliveryManOrders')
                .doc('$orderNumber')
                .delete(),
          );
    },
  );
}
