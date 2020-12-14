import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class Deliveries extends StatefulWidget {
  @override
  _DeliveriesState createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  int count = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      int ans = await Provider.of<UserProvider>(context, listen: false).getTotalOrderDelivered();
      setState(() {
        count = ans;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'profile');
            },
            child: Icon(FontAwesomeIcons.solidUserCircle)),
        title: Text('Delivery'),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'create');
              },
              child: Text('$count Completed', style: kLargeWhiteTextStyle),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Container(
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db.collection('orders').orderBy('order_created_date', descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      );
                    }
                    final orders = snapshot.data.docs;
                    List<Widget> orderWidget = [];
                    for (var order in orders) {
                      if (order['delivered_by'] == userProvider.loggedInUser.docID && order['is_delivered'] == false) {
                        orderWidget.add(
                          Card(
                            margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: size.width * 0.9,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: kPrimaryColor),
                                      SizedBox(width: 10),
                                      Text(order['name'], style: kOrderCardTextStyle),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: kPrimaryColor),
                                      SizedBox(width: 10),
                                      Text(order['address'], style: kOrderCardTextStyle),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: kPrimaryColor),
                                      SizedBox(width: 10),
                                      Text(order['phone'], style: kOrderCardTextStyle),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(FontAwesomeIcons.pills, color: kPrimaryColor),
                                      SizedBox(width: 10),
                                      Text(order['order_details'], style: kOrderCardTextStyle),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Expanded(child: Container()),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {},
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
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            orderProvider.selectedForDelivery = OrderModel(
                                              name: order['name'],
                                              address: order['address'],
                                              phoneNumber: order['phone'],
                                              orderDetails: order['order_details'],
                                              amount: order['amount'],
                                              orderDocID: order.id,
                                            );
                                            Navigator.pushNamed(context, 'orderDetails');
                                          },
                                          child: Text(
                                            'Start',
                                            style: kWhiteButtonTextStyle,
                                            maxLines: 1,
                                          ),
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return Column(
                      children: orderWidget,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
