import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeName extends StatefulWidget {
  const EmployeeName({Key? key}) : super(key: key);

  @override
  State<EmployeeName> createState() => _EmployeeNameState();
}

class _EmployeeNameState extends State<EmployeeName> {
  String employeeName = "";
  final Future<DocumentSnapshot> deliveryManDoc = FirebaseFirestore.instance
      .collection('deliveryMans')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .get();

  void getEmployeeName() async{
    String employee = await deliveryManDoc.then((value) => value.get('name'));
    setState(() {
      employeeName = employee;
    });
  }

  @override
  void initState() {
    super.initState();
    getEmployeeName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Сотрудник $employeeName',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
