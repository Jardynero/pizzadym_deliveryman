import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/db/db.dart';
import 'package:pizzadym_deliveryman/models/models.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class AdminOrdersPanel extends StatelessWidget {
  final int currentIndex;
  AdminOrdersPanel({
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  final Stream<QuerySnapshot> orders = FirebaseFirestore.instance
      .collection('deliveryManOrders')
      .orderBy('orderNumber', descending: true)
      .snapshots();

  final String adminEmail = GlobalData.adminEmail;
  final String developerEmail = GlobalData.developerEmail;
  final String? userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новые заказы'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.docs.isEmpty && userEmail == adminEmail || userEmail == developerEmail) {
            return const Center(
              child: Text('Новых заказов пока нет!'),
            );
          }
          if (userEmail == adminEmail || userEmail == developerEmail) {
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
          }
          return const Center(
            child: Text(
              'У вас нет прав, для просмотра этой страницы! Перейдите в раздел "Мои заказы"',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
