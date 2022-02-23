import 'package:flutter/material.dart';

class DeliveryMethodeLeading extends StatelessWidget {
  final String deliveryMethod;
  const DeliveryMethodeLeading({
    Key? key,
    required this.deliveryMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(deliveryMethod),
    );
  }
}
