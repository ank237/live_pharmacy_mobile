import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BoxModel> boxValues = [
    BoxModel(onTapFunc: 'latest', image: 'latest', name: 'Latest'),
    BoxModel(onTapFunc: 'ongoing', image: 'ongoing', name: 'Ongoing Deliveries'),
    BoxModel(onTapFunc: 'scheduled', image: 'schedule', name: 'Scheduled deliveries'),
    BoxModel(onTapFunc: 'past', image: 'past', name: 'Past Deliveries'),
    BoxModel(onTapFunc: 'payments', image: 'payments', name: 'Payments'),
    BoxModel(onTapFunc: 'notes', image: 'notes', name: 'Notes'),
  ];

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              content: Text(
                'Do you want to exit the app',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
              child: Icon(FontAwesomeIcons.solidUserCircle)),
          title: Text('Live Pharmacy'),
          actions: [
            InkWell(
              child: Icon(FontAwesomeIcons.solidBell),
              onTap: () {
                Navigator.pushNamed(context, 'upcomingReminders');
              },
            ),
            SizedBox(width: 10),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'create');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  child: Text(
                    '+   NEW',
                    style: kAppbarButtonTextStyle,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: GridView.builder(
                  itemCount: boxValues.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return HomePageBox(
                      name: boxValues[index].name,
                      image: boxValues[index].image,
                      onTapFunc: boxValues[index].onTapFunc,
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.7,
                  child: FlatButton(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    onPressed: () {
                      Navigator.pushNamed(context, 'verifyUsers');
                    },
                    child: Text('Verify Users', style: kLargeWhiteTextStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxModel {
  String name;
  String image;
  String onTapFunc;

  BoxModel({
    this.onTapFunc,
    this.image,
    this.name,
  });
}

class HomePageBox extends StatelessWidget {
  final String name;
  final String image;
  final String onTapFunc;

  HomePageBox({
    @required this.name,
    @required this.image,
    @required this.onTapFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, onTapFunc);
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(name, style: kHomePageCardHeadingTextStyle),
              Image(
                image: AssetImage('assets/$image.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
