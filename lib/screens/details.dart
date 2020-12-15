import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: kPrimaryColor),
                    SizedBox(width: 10),
                    Text(orderProvider.selectedOrder.name, style: kOrderCardTextStyle),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: kPrimaryColor),
                    SizedBox(width: 10),
                    Text(orderProvider.selectedOrder.address, style: kOrderCardTextStyle),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text(orderProvider.selectedOrder.phoneNumber, style: kOrderCardTextStyle),
                      ],
                    ),
                    Container(
                      width: 100,
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          'Call',
                          style: kWhiteButtonTextStyle,
                          maxLines: 1,
                        ),
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.pills, color: kPrimaryColor),
                    SizedBox(width: 10),
                    Text(orderProvider.selectedOrder.orderDetails, style: kOrderCardTextStyle),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.rupeeSign, color: kPrimaryColor),
                    SizedBox(width: 10),
                    Text(orderProvider.selectedOrder.amount, style: kOrderCardTextStyle),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
