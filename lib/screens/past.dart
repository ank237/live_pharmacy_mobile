import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';

class PastOrder extends StatefulWidget {
  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Past deliveries'),
      ),
      body: Container(
        width: size.width,
        child: Column(
          children: [
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
                      if (order['is_delivered'] == true) {
                        DateTime date = order['delivered_on'].toDate();
                        orderWidget.add(
                          Card(
                            margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: size.width * 0.9,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString(), style: kLargeBlueTextStyle),
                                  SizedBox(height: 15),
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
                                      SizedBox(width: 75),
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
                                      SizedBox(width: 75),
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
        ),
      ),
    );
  }
}