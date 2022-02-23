import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/models/models.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class NewOrder extends StatelessWidget {
  final OrderData order;
  final int currentIndex;
  const NewOrder({
    required this.order,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Новый заказ #${order.orderNumber}',
      ),
      leading: const Icon(Icons.pending_outlined),
      trailing: DeliveryMethodeLeading(
        deliveryMethod: order.deliveryMethod,
      ),
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: Colors.black,
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return AdminOrderPreview(orderData: order, currentIndex: currentIndex,);
          },
        );
      },
    );
  }
}
