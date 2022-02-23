class OrderData {
  // Информация о заказе
  final int orderNumber;
  final String deliveryMethod;
  final String deliveryTime;
  final List orderItems;
  final int totalAmount;
  final String paymentMethod;
  final dynamic changeFrom;
  final String comment;

  // Информация о клиенте
  final String token;
  final String clientName;
  final String clientPhoneNumber;
  bool pushOrderConfirmed;
  bool pushOrderInDelivery;
  bool pushOrderDelivered;

  // Адрес доставки
  final dynamic adress;
  final dynamic adressDetails;

  OrderData({
    required this.orderNumber,
    required this.deliveryMethod,
    required this.deliveryTime,
    required this.orderItems,
    required this.totalAmount,
    required this.paymentMethod,
    required this.changeFrom,
    required this.comment,
    required this.token,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.pushOrderConfirmed,
    required this.pushOrderInDelivery,
    required this.pushOrderDelivered,
    required this.adress,
    required this.adressDetails,
  });
}
