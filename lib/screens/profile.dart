import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/functions/functions.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late bool _isDarkTheme;
  final DocumentReference deliveryManDoc = FirebaseFirestore.instance
      .collection('deliveryMans')
      .doc(FirebaseAuth.instance.currentUser!.email);

  @override
  void initState() {
    super.initState();
    _isDarkTheme = StockLocalData.getBoolData('dark_theme') ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль курьера'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const EmployeeName(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: SwitchListTile.adaptive(
                  title: const Text('Темная версия'),
                  value: _isDarkTheme,
                  onChanged: (value) async{
                    setState(() => _isDarkTheme = value);
                    await StockLocalData.saveBoolData('dark_theme', value);
                    Provider.of<StockLocalData>(context, listen: false).changeThemeMode();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: ButtonIcon(
              label: 'Выйти',
              icon: Icons.exit_to_app,
              onPressed: () async {
                _auth.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
