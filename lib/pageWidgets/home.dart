import 'package:capstone/pageWidgets/registerCreator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'Registration.dart';
import 'home.dart';
import 'homeWidgets/map.dart';
import 'homeWidgets/homeMain.dart';
import '../utilWidgets/geolocator.dart';
import 'homeWidgets/explore.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  HomePageState createState(){
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  int screenIndex = 0;
  List<Widget>? widgetPages;
  var user;
  var userEmail;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      print("Error it doesn't seem a user is signed in");
      Navigator.pushNamedAndRemoveUntil(context, "landing", (r) => false);
    }
    widgetPages = <Widget>[
      HomeMainWidget(user:user),
      ExploreWidget(),
      MapWidget()
    ];
    super.initState();
  }

  //list of views accessible after login
  static const List<String> pageTitles = <String>[
    "Home",
    "Explore",
    "Activity Map",

  ];

  void _onItemTapped(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("$userEmail"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, "landing", (r) => false);

                // signOut(context);
                //Navigator.pushReplacementNamed(context, "/");//should be changed to pop

                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Other feature'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(

        title: Text(pageTitles[screenIndex]),
      ),
    body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
        image: NetworkImage(
        'https://i.pinimg.com/originals/1a/7a/0c/1a7a0cc45910acf9fac16b292c7034c7.jpg'),
    fit: BoxFit.cover),
    ),
      child: widgetPages?.elementAt(screenIndex)
      // child: PageView(
      //   controller: controller,
      //   children: <Widget>[
      //     Center(
      //         child: Column(
      //           children: <Widget>[
      //             Container(
      //               color: Colors.lightBlue,
      //               height:  200,
      //               width: 200,
      //             )
      //           ],
      //         )
      //     ),
      //
      //   ]
      // )
    ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'School',
          ),
        ],
          currentIndex: screenIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,

      ),
    );
  }
}