import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class ScheduledDeliveries extends StatefulWidget {
  @override
  _ScheduledDeliveriesState createState() => _ScheduledDeliveriesState();
}

class _ScheduledDeliveriesState extends State<ScheduledDeliveries> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      orderProvider.fetchAgents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Deliveries'),
      ),
      body: Container(
        width: size.width,
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            DateTime date = DateTime.now().add(Duration(days: index + 1));
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString(), style: kLargeBlueTextStyle),
                ),
                Flexible(
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
                          if (order['is_repeating'] == true) {
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
                                          Text(order['address'], style: kOrderCardTextStyle),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FlatButton(
                                              onPressed: () {},
                                              child: Text('Cancel Order', style: kWhiteButtonTextStyle),
                                              color: kCancelButtonColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
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
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: FlatButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Container(
                                                        height: size.height * 0.25,
                                                        child: ListView.builder(
                                                          itemCount: orderProvider.agentList.length,
                                                          itemBuilder: (context, index) {
                                                            var agent = orderProvider.agentList[index];
                                                            return ListTile(
                                                              title: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(agent.name),
                                                                  Text(agent.phone),
                                                                ],
                                                              ),
                                                              trailing: FlatButton(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                color: kPrimaryColor,
                                                                child: Text('Assign', style: kWhiteButtonTextStyle),
                                                                onPressed: () {
                                                                  orderProvider.assignAgent(order.id, agent.docId, agent.name);
                                                                  Navigator.pop(context);
                                                                  Fluttertoast.showToast(msg: '${agent.name} assigned for this order');
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Text('Assign agent', style: kWhiteButtonTextStyle),
                                              color: kPrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          )
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}