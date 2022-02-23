import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/models/models.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class CurrentOrders extends StatelessWidget {
  final int currentIndex;
  CurrentOrders({
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  final Stream<QuerySnapshot> orders = FirebaseFirestore.instance
      .collection('deliveryMans')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('orders')
      .orderBy('orderNumber', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Текущие заказы'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Новых заказов пока нет!'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return NewOrder(
                  order: OrderData(
                    orderNumber: data['orderNumber'],
                    deliveryMethod: data['deliveryMethod'],
                    deliveryTime: data['deliveryTime'],
                    orderItems: data['orderItems'],
                    totalAmount: data['totalAmount'],
                    paymentMethod: data['paymentMethod'],
                    changeFrom: data['changeFrom'],
                    comment: data['comment'],
                    token: data['token'],
                    clientName: data['clientName'],
                    clientPhoneNumber: data['clientPhoneNumber'],
                    pushOrderConfirmed: data['push_order_confirmed'],
                    pushOrderInDelivery: data['push_order_in_delivery'],
                    pushOrderDelivered: data['push_order_delivered'],
                    adress: data['adress'],
                    adressDetails: data['adressDetails'],
                  ),
                  currentIndex: currentIndex,
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
