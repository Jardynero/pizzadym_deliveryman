import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class ItemListPopUp extends StatelessWidget {
  final List items;
  const ItemListPopUp({
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Состав заказа'),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final item in items) Text(item),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ButtonIcon(
            label: 'Закрыть',
            icon: Icons.close_outlined,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
