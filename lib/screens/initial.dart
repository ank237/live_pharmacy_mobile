import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> checkLogin() async {
    if (_auth.currentUser != null) {
      setState(() {
        _isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.getCurrentUser(_auth.currentUser.phoneNumber);
      setState(() {
        _isLoading = false;
      });
      if (userProvider.loggedInUser.isVerified) {
        if (userProvider.loggedInUser.role == 'agent') {
          Navigator.pushNamed(context, 'deliveries');
        } else {
          Navigator.pushNamed(context, 'home');
        }
      } else {
        Navigator.pushNamed(context, 'verify');
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      checkLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Pharmacy'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login as', style: kLargeBlueTextStyle),
              SizedBox(height: 30),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false).selectedRole = 'admin';
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text('ADMIN', style: kLargeWhiteTextStyle),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false).selectedRole = 'manager';
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text('MANAGER', style: kLargeWhiteTextStyle),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false).selectedRole = 'agent';
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text('DELIVERY AGENT', style: kLargeWhiteTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
