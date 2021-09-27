import 'map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

//registration form for a Creator
//fields:
//username
//email
//password
//address (used for proximity to users that are exploring on map or explore page)
class CreatorRegistrationForm extends StatefulWidget {
  const CreatorRegistrationForm({Key? key}) : super(key: key);

  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}
//state implementation of Creator form
class RegistrationFormState extends State<CreatorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top:20),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: 'Creator Registration',
                  style: GoogleFonts.abhayaLibre(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 50,
                      ))),
            ]

              // style: TextStyle(fontFamily: 'RototoMono')
            )),
      ),

      Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Column(
              children: <Widget>[
                //form field for email
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid email";
                          }
                          return null;
                        })),
                //form field for username (optional)
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Username (optional)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            //if empty, this is ok
                            return "Please enter valid password";
                          }
                          return null;
                        })),
                //form field for password
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid password";
                          }
                          return null;
                        })),
                //form field for address
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Address',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid address";
                          }
                          return null;
                        })),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: Text('Register'),
                    )
                )
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          )),
    ]);
  }
}
//page registration widget for signing up as a Creator
class CreatorRegistrationPage extends StatefulWidget{
  CreatorRegistrationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CreatorRegistrationPageState createState() => _CreatorRegistrationPageState();
}


class _CreatorRegistrationPageState extends State<CreatorRegistrationPage> {
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
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
              child: SingleChildScrollView(
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
                    CreatorRegistrationForm()
                    // Text(
                    //   'You have clicked the button this many times:',
                    // ),
                    // Text(
                    //   '$_counter',
                    //   style: Theme.of(context).textTheme.headline4,
                    // ),
                  ],
                ),
              )
            )));
  }
}