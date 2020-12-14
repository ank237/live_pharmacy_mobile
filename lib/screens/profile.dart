import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).loggedInUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: Column(
          children: [
            Text(user.name),
            Container(
              width: size.width,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushNamed(context, 'initial');
                },
                child: Text('LOGOUT', style: kLargeWhiteTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
