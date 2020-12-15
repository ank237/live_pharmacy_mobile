class OrderModel {
  String name;
  String address;
  String phoneNumber;
  String orderDetails;
  String amount;
  DateTime date;
  bool isRepeating;
  bool isDelivered;
  String deliveredBy;
  String deliveredOn;
  String modeOfPayment;
  bool isPaid;
  DateTime orderCreatedDate;
  String orderDocID;
  String screenshot;

  OrderModel({
    this.name,
    this.screenshot,
    this.phoneNumber,
    this.date,
    this.amount,
    this.address,
    this.deliveredBy,
    this.deliveredOn,
    this.isDelivered,
    this.isPaid,
    this.isRepeating,
    this.modeOfPayment,
    this.orderCreatedDate,
    this.orderDetails,
    this.orderDocID,
  });
}
