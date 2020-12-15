import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';

class Verification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'profile');
          },
          child: Icon(FontAwesomeIcons.solidUserCircle),
        ),
        title: Text('Live Pharmacy'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Text(
            'You are not verified yet! Please try again later',
            style: kLargeBlueTextStyle,
          ),
        ),
      ),
    );
  }
}
