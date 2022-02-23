import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/functions/functions.dart';
import 'package:pizzadym_deliveryman/screens/screens.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<List> _pagesBottomNavBarItems = [
    [const Icon(Icons.format_list_bulleted_rounded), 'Админ'],
    [const Icon(Icons.local_shipping_outlined), 'Мои заказы'],
    [const Icon(Icons.person), 'Профиль'],
  ];

  void saveToken() async {
    UpdateFieldInFirestore(
      collection: 'deliveryMans',
      doc: FirebaseAuth.instance.currentUser!.email!,
      fieldNameToUpdate: 'token',
      value: await FirebaseMessaging.instance.getToken(),
    ).updateValue();
    await FirestoreNotifications().foregroundNotifications();
  }
  
  @override
  void initState() {
    super.initState();
    saveToken();
  }

  @override
  Widget build(BuildContext context) {
    final List _screens = [
      AdminOrdersPanel(currentIndex: _currentIndex),
      CurrentOrders(currentIndex: _currentIndex),
      const Profile(),
    ];
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        pagesItem: _pagesBottomNavBarItems,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
    );
  }
}
