//Implementation of general scaffold to hold elements for pages
//explore page
//home page
//map page
//Contains scaffold settings and buttons for creating posts
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homeMain.dart';
import 'mapWidget.dart';
import 'exploreWidget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../postWidgets/postPage.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  HomeScaffoldState createState() {
    return HomeScaffoldState();
  }
}

class HomeScaffoldState extends State<HomeScaffold>  {
  int screenIndex = 0;
  List<Widget>? widgetPages;
  PageController? _pageController;

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
      HomeMainWidget(user: user),
      ExploreWidget(user: user),
      MapWidget()
    ];
    _pageController = PageController(initialPage: screenIndex);
    super.initState();
  }
  @override
  void dispose(){
    _pageController!.dispose();
    super.dispose();
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
      _pageController!.jumpToPage(screenIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    //for automatic keepalive
    // super.build(context);
    return Scaffold(
      floatingActionButton: Visibility(
        visible: screenIndex == 0 ? true : false,
        child: SpeedDial(
          icon: Icons.add,
          backgroundColor: Colors.lightBlue,
          // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.video_call),
              backgroundColor: Colors.lightBlue[600],
              foregroundColor: Colors.white,
              label: 'Post Video',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostPage(formType: 'video', user: user))),
            ),
            SpeedDialChild(
                child: const Icon(Icons.add_a_photo),
                backgroundColor: Colors.lightBlue[700],
                foregroundColor: Colors.white,
                label: 'Post Image',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostPage(formType: 'image', user: user)))),
            SpeedDialChild(
                child: const Icon(Icons.add_location),
                backgroundColor: Colors.lightBlue[800],
                foregroundColor: Colors.white,
                label: 'Post Location',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostPage(formType: 'location', user: user)))),
            SpeedDialChild(
              child: const Icon(Icons.message),
              backgroundColor: Colors.lightBlue[900],
              foregroundColor: Colors.white,
              label: 'Post Caption',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostPage(formType: 'caption', user: user))),
            ),
          ],
        ),
      ),
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
                Navigator.pushNamedAndRemoveUntil(
                    context, "landing", (r) => false);

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
        elevation: 0.0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        // title: Text(pageTitles[screenIndex]),
        title: RichText(
            text: TextSpan(
                style: GoogleFonts.abhayaLibre(
                    textStyle: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    )),
                children: [
                  TextSpan(
                    text: '${pageTitles[screenIndex]}',
                  ),
                ])),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/originals/1a/7a/0c/1a7a0cc45910acf9fac16b292c7034c7.jpg'),
                fit: BoxFit.cover),
          ),
          child: PageView(
            controller: _pageController,
            physics:NeverScrollableScrollPhysics(),
            children: widgetPages!,
          )
          // widgetPages?.elementAt(screenIndex)
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
            label: 'Activity Map',
          ),
        ],
        currentIndex: screenIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  // @override

  // bool get wantKeepAlive => true;
}
