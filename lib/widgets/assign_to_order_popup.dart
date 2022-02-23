import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/functions/functions.dart';
import 'package:pizzadym_deliveryman/models/models.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class AssignToOrderPopup extends StatefulWidget {
  final OrderData orderData;
  const AssignToOrderPopup({
    required this.orderData,
    Key? key,
  }) : super(key: key);

  @override
  State<AssignToOrderPopup> createState() => _AssignToOrderPopupState();
}

class _AssignToOrderPopupState extends State<AssignToOrderPopup> {
  String _selectedEmployeeId = '';
  String _selectedEmployeeToken = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('deliveryMans').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return SimpleDialog(
            title: const Text('Выбрать сотрудника'),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return RadioListTile(
                        title: Text(data['name']),
                        value: document.id,
                        groupValue: _selectedEmployeeId,
                        onChanged: (dynamic value) {
                          setState(() {
                            _selectedEmployeeId = value;
                            _selectedEmployeeToken = data['token'];
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: ButtonIcon(
                  label: 'Назначить',
                  icon: Icons.check,
                  onPressed: () async {
                    duplicateFirestoreDoc(
                      widget.orderData.orderNumber,
                      _selectedEmployeeId,
                    );
                    await PushNotifications(
                            title: 'Пицца Дым Курьер',
                            message: 'Вы назначены на заказ',
                            token: _selectedEmployeeToken)
                        .sendPush();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
