//Capstone Project (Artsy) application entry point
import 'package:capstone/pageWidgets/registration/registerCreator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'registration/registrationStart.dart';
import 'homeWidgets/homeScaffold.dart';
import '../utilWidgets/signInForm.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //inflate MyApp() and attach to screen
  //MyApp is a Widget
  runApp(MyApp());
}

//Beginning of my app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.lightBlueAccent),
        ),
        initialRoute: 'landing',
        routes: {
          'landing': (context) => LandingPage(title: 'Landing Page'),
          'registration': (context) => RegistrationPage(title: "Registration"),
          'creatorRegistration': (context) =>
              CreatorRegistrationPage(title: "New Creator"),
          'userHome': (context) => HomeScaffold(title: 'Home')
        });
  }
}

//CUSTOM WIDGET
//SignInForm
//utilized for login page
//used to get user credentials
//if valid credentials, log user
//reject credentials otherwise

//SIGN IN PAGE
class LandingPage extends StatefulWidget {
  LandingPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  //INITIALIZE FIREBASE APPLICATION
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //build State<MyHomePage>
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //FUTURE BUILDER OPENS SIGN IN PAGE WHEN FIREBASE IS INITIALIZED
    //builder will navigate to user's home page if already signed in
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // FirebaseAuth.instance
            //     .idTokenChanges()
            //     .listen((User? user) {
            //       var localUser = user;
            //   if (localUser != null) {
            //     Navigator.pushNamed(
            //         context, 'userHome'
            //     );
            //   }
            //     }
            //   );
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
              ),
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://i.pinimg.com/originals/1a/7a/0c/1a7a0cc45910acf9fac16b292c7034c7.jpg'),
                        fit: BoxFit.cover),
                  ),
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Center(
                    child: Column(
                      // Column is also a layout widget. It takes a list of children and
                      // arranges them vertically. By default, it sizes itself to fit its
                      // children horizontally, and tries to be as tall as its parent.
                      //
                      // Invoke "debug painting" (press "p" in the console, choose the
                      // "Toggle Debug Paint" action from the Flutter Inspector in Android
                      // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                      // to see the wireframe for each widget.
                      //
                      // Column has various properties to control how it sizes itself and
                      // how it positions its children. Here we use mainAxisAlignment to
                      // center the children vertically; the main axis here is the vertical
                      // axis because Columns are vertical (the cross axis would be
                      // horizontal).
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SignInForm(),
                        // Text(
                        //   'You have clicked the button this many times:',
                        // ),
                        // Text(
                        //   '$_counter',
                        //   style: Theme.of(context).textTheme.headline4,
                        // ),
                      ],
                    ),
                  )),
              // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
