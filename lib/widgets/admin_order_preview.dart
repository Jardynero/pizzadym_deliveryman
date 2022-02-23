import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/db/db.dart';
import 'package:pizzadym_deliveryman/functions/functions.dart';
import 'package:pizzadym_deliveryman/models/models.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminOrderPreview extends StatefulWidget {
  final OrderData orderData;
  final int currentIndex;
  const AdminOrderPreview({
    required this.orderData,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<AdminOrderPreview> createState() => _AdminOrderPreviewState();
}

class _AdminOrderPreviewState extends State<AdminOrderPreview> {
  final String adminEmail = GlobalData.adminEmail;

  final String developerEmail = GlobalData.developerEmail;

  final String? userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DeliveryMethodeLeading(
                    deliveryMethod: widget.orderData.deliveryMethod),
                Text(
                  'Заказ №${widget.orderData.orderNumber} на ${widget.orderData.totalAmount}₽',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(widget.orderData.deliveryTime,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Visibility(
              visible: widget.currentIndex == 0 ? true : false,
              child: ButtonIcon(
                label: 'Потвердить заказ (Push)',
                icon: Icons.check_outlined,
                onPressed: widget.orderData.pushOrderConfirmed == true
                    ? null
                    : () async {
                        setState(
                            () => widget.orderData.pushOrderConfirmed = true);
                        await PushNotifications(
                          message:
                              'Ваш заказ принят! Будем держать вас в курсе',
                          token: widget.orderData.token,
                          title: 'Пицца ДЫм',
                        ).sendPush();
                        UpdateFieldInFirestore(
                          collection: 'deliveryManOrders',
                          doc: widget.orderData.orderNumber.toString(),
                          fieldNameToUpdate: 'push_order_confirmed',
                          value: true,
                        ).updateValue();
                        UpdateFieldInFirestore(
                          collection: 'users',
                          secondCollection: 'orders',
                          doc: widget.orderData.clientPhoneNumber,
                          secondDoc: widget.orderData.orderNumber.toString(),
                          fieldNameToUpdate: 'Статус заказа',
                          value: 1,
                        ).updateValueInSecondCollection();
                      },
              ),
            ),
            Visibility(
              visible: widget.currentIndex == 0 ? true : false,
              child: ButtonIcon(
                label: widget.orderData.deliveryMethod == 'Доставка'
                    ? 'Назначить курьера на заказ'
                    : 'Назначить ответственного',
                icon: Icons.local_shipping_outlined,
                onPressed: widget.orderData.pushOrderConfirmed == true
                    ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AssignToOrderPopup(
                              orderData: widget.orderData,
                            );
                          },
                        );
                      }
                    : null,
              ),
            ),
            Visibility(
              visible: widget.currentIndex == 0 ? false : true,
              child: ButtonIcon(
                label: widget.orderData.deliveryMethod == 'Доставка'
                    ? 'Забрал заказ (Push)'
                    : 'Заказ готов (Push)',
                icon: Icons.local_shipping_outlined,
                onPressed: widget.orderData.pushOrderInDelivery == true
                    ? null
                    : () {
                        setState(
                            () => widget.orderData.pushOrderInDelivery = true);
                        PushNotifications(
                          message: widget.orderData.deliveryMethod == 'Доставка'
                              ? 'Курьер уже спешит к Вам!'
                              : 'Ваш заказ готов к выдаче, мы Вас ждем)',
                          token: widget.orderData.token,
                          title: 'Пицца Дым',
                        ).sendPush();
                        UpdateFieldInFirestore(
                          collection: 'deliveryMans',
                          secondCollection: 'orders',
                          doc: userEmail!,
                          secondDoc: widget.orderData.orderNumber.toString(),
                          fieldNameToUpdate: 'push_order_in_delivery',
                          value: true,
                        ).updateValueInSecondCollection();
                        UpdateFieldInFirestore(
                          collection: 'users',
                          secondCollection: 'orders',
                          doc: widget.orderData.clientPhoneNumber,
                          secondDoc: widget.orderData.orderNumber.toString(),
                          fieldNameToUpdate: 'Статус заказа',
                          value: 2,
                        ).updateValueInSecondCollection();
                      },
              ),
            ),
            Visibility(
              visible: widget.currentIndex == 0 ? false : true,
              child: ButtonIcon(
                label: widget.orderData.deliveryMethod == 'Доставка'
                    ? 'Заказ доставлен (Push)'
                    : 'Заказ отдан гостю (Push)',
                icon: Icons.check_circle_outline,
                onPressed: widget.orderData.pushOrderDelivered == true
                    ? null
                    : () {
                        setState(
                            () => widget.orderData.pushOrderDelivered = true);
                        PushNotifications(
                                message: widget.orderData.deliveryMethod ==
                                        'Доставка'
                                    ? 'Заказ доставлен 🏁 Спасибо, что выбрали Пиццу Дым!'
                                    : 'Заказ выдан 🏁 Спасибо, что выбрали Пиццу Дым!',
                                token: widget.orderData.token,
                                title: 'Пицца Дым')
                            .sendPush();
                        UpdateFieldInFirestore(
                          collection: 'deliveryMans',
                          secondCollection: 'orders',
                          doc: userEmail!,
                          secondDoc: widget.orderData.orderNumber.toString(),
                          fieldNameToUpdate: 'push_order_delivered',
                          value: true,
                        ).updateValueInSecondCollection();
                        UpdateFieldInFirestore(
                          collection: 'users',
                          secondCollection: 'orders',
                          doc: widget.orderData.clientPhoneNumber,
                          secondDoc: widget.orderData.orderNumber.toString(),
                          fieldNameToUpdate: 'Статус заказа',
                          value: 3,
                        ).updateValueInSecondCollection();
                        DeleteDeliveredOrder(
                          collection: 'deliveryMans',
                          secondCollection: 'orders',
                          doc: userEmail!,
                          secondDoc: widget.orderData.orderNumber.toString(),
                        ).deleteOrder();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          reUsableSnackBar('Заказ успешно закрыт!', context),
                        );
                      },
              ),
            ),
            const SizedBox(height: 10.0),
            Visibility(
              visible:
                  widget.orderData.deliveryMethod == 'Доставка' ? true : false,
              child: OrderPreviewSection(
                sectionTitle: 'Адрес доставки',
                sectionDescription:
                    '${widget.orderData.adress} \n\nДетали: ${widget.orderData.adressDetails}',
              ),
            ),
            Visibility(
              visible:
                  widget.orderData.deliveryMethod == 'Доставка' ? true : false,
              child: OrderPreviewSection(
                sectionTitle: 'Метод оплаты',
                sectionDescription: widget.orderData.paymentMethod == 'картой'
                    ? 'Оплата банковской картой при получении \nСдача не требуется!'
                    : 'Оплата наличными \nПодготовить сдачу с ${widget.orderData.changeFrom}₽',
              ),
            ),
            Visibility(
              visible:
                  widget.orderData.deliveryMethod == 'Доставка' ? true : false,
              child: OrderPreviewSection(
                sectionTitle: 'Комментарий клиента',
                sectionDescription: widget.orderData.comment.isEmpty
                    ? 'Клиент не указал комментарий'
                    : widget.orderData.comment,
              ),
            ),
            const SizedBox(height: 10.0),
            ButtonIcon(
              label: 'Посмотреть состав заказа',
              icon: Icons.list_outlined,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ItemListPopUp(
                      items: widget.orderData.orderItems,
                    );
                  },
                );
              },
            ),
            ButtonIcon(
              label: 'Позвонить клиенту - ${widget.orderData.clientName}',
              icon: Icons.phone_iphone_outlined,
              onPressed: () async {
                await launch('tel://${widget.orderData.clientPhoneNumber}');
              },
            ),
            const SizedBox(height: 10.0),
            Visibility(
              visible: widget.currentIndex == 0 ? true : false,
              child: CancelOrderButton(
                label: 'Отменить заказ',
                icon: Icons.close_outlined,
                onPressed: () async {
                  await PushNotifications(
                    message: 'Заказ отменен ❌',
                    token: widget.orderData.token,
                    title: 'Пицца Дым',
                  ).sendPush();
                  UpdateFieldInFirestore(
                    collection: 'users',
                    secondCollection: 'orders',
                    doc: widget.orderData.clientPhoneNumber,
                    secondDoc: widget.orderData.orderNumber.toString(),
                    fieldNameToUpdate: 'Статус заказа',
                    value: 3,
                  ).updateValueInSecondCollection();
                  DeleteDeliveredOrder(
                    collection: 'deliveryManOrders',
                    doc: '${widget.orderData.orderNumber}',
                  ).deleteOrderWhenOrderCanceled();
                  ScaffoldMessenger.of(context).showSnackBar(
                    reUsableSnackBar('Заказ успешно отменен!', context),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
