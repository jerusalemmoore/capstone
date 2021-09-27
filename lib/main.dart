
import 'package:capstone/registerCreator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'Registration.dart';

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
          primarySwatch: Colors.blue,
          accentColor: Colors.lightBlueAccent,
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) => MyHomePage(title: 'Landing Page'),
          'registration': (context) => RegistrationPage(title: "Registration"),
          'creatorRegistration': (context) => CreatorRegistrationPage(title: "New Creator")
        });
  }
}

//CUSTOM WIDGET
//SignInForm
//utilized for login page
//used to get user credentials
//if valid credentials, log user
//reject credentials otherwise
class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(children: <Widget>[
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'ARTSY',
            style: GoogleFonts.abhayaLibre(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 50,
            ))),
      ]

              // style: TextStyle(fontFamily: 'RototoMono')
              )),
      Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'User name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter username";
                          }
                          return null;
                        })),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter username";
                          }
                          return null;
                        })),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: "Don't have an account? Register "),
                            TextSpan(
                                style: TextStyle(color: Colors.pink),
                                text: "here",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, 'registration');
                                  }

                                // print('Terms of Service"');
                                ),
                          ]),
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () { },
                    child: Text('Login'),
                  )
                )


                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          )),

    ]);
  }
}

//SIGN IN PAGE
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //INITIALIZE FIREBASE APPLICATION
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
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
