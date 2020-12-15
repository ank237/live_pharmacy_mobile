import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  String dropDownValue = 'All Methods';
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: size.width,
        child: Column(
          children: [
            Row(
              children: [
                Text('Show', style: kBlueTextStyle),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                    value: dropDownValue,
                    items: ['All Methods', 'GPay', 'PhonePe', 'Paytm', 'Cash', 'PayLater']
                        .map((label) => DropdownMenuItem(
                              child: Text(label.toString()),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db.collection('orders').orderBy('order_created_date', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      );
                    }
                    final orders = snapshot.data.docs;
                    List<Widget> orderWidget = [];
                    for (var order in orders) {
                      if (dropDownValue != 'All Methods') {
                        if (order['is_delivered'] == true && order['mode_of_payment'] == dropDownValue) {
                          DateTime date = order['order_created_date'].toDate();
                          orderWidget.add(
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString(), style: kAppbarButtonTextStyle),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person, color: kPrimaryColor),
                                          SizedBox(width: 5),
                                          Text(order['name'], style: kOrderCardTextStyle),
                                        ],
                                      ),
                                      Expanded(
                                        child: Image(
                                          image: AssetImage('assets/${order['mode_of_payment']}.png'),
                                        ),
                                      ),
                                      Text('Rs ' + order['amount'], style: kBlueTextStyle),
                                      SizedBox(width: 10),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {
                                            orderProvider.selectedOrder = OrderModel(
                                              name: order['name'],
                                              address: order['address'],
                                              phoneNumber: order['phone'],
                                              orderDetails: order['order_details'],
                                              amount: order['amount'],
                                              orderDocID: order.id,
                                              screenshot: order['screenshot'],
                                            );
                                            Navigator.pushNamed(context, 'details');
                                          },
                                          child: Text(
                                            'Order details',
                                            style: kWhiteButtonTextStyle,
                                            maxLines: 1,
                                          ),
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        if (order['is_delivered'] == true) {
                          DateTime date = order['delivered_on'].toDate();
                          orderWidget.add(
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString(), style: kAppbarButtonTextStyle),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person, color: kPrimaryColor),
                                          SizedBox(width: 5),
                                          Text(order['name'], style: kOrderCardTextStyle),
                                        ],
                                      ),
                                      Expanded(
                                        child: Image(
                                          image: AssetImage('assets/${order['mode_of_payment']}.png'),
                                        ),
                                      ),
                                      Text('Rs ' + order['amount'], style: kBlueTextStyle),
                                      SizedBox(width: 10),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {
                                            orderProvider.selectedOrder = OrderModel(
                                              name: order['name'],
                                              address: order['address'],
                                              phoneNumber: order['phone'],
                                              orderDetails: order['order_details'],
                                              amount: order['amount'],
                                              orderDocID: order.id,
                                            );
                                            Navigator.pushNamed(context, 'details');
                                          },
                                          child: Text(
                                            'Order details',
                                            style: kWhiteButtonTextStyle,
                                            maxLines: 1,
                                          ),
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    }
                    return Column(
                      children: orderWidget,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
