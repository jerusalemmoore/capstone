import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//registration form for a Creator
//fields:
//username
//email
//password
//address (used for proximity to users that are exploring on map or explore page)
class CaptionForm extends StatefulWidget {
  const CaptionForm({Key? key}) : super(key: key);

  @override
  CaptionFormState createState() {
    return CaptionFormState();
  }
}

//state implementation of Creator form
//Value fields:
// String username;
// String email;
// String password;
// String address;
class CaptionFormState extends State<CaptionForm> {
  dynamic _validationMsg;
  bool _isChecking = false;
  var username;
  var email;
  var password;
  var address;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    usernameController.addListener(setUsername);
    emailController.addListener(setEmail);
    passwordController.addListener(setPassword);
    addressController.addListener(setAddress);
    super.initState();
  }

  //SET METHODS
  //update fields according to controller text vals
  void setUsername() {
    username = usernameController.text;
  }

  void setEmail() {
    email = emailController.text;
  }

  void setPassword() {
    password = passwordController.text;
  }

  void setAddress() {
    address = addressController.text;
  }

  //Add extended creator credentials in doc where docId = email
  Future<bool> addCreator() async {
    CollectionReference creators =
    FirebaseFirestore.instance.collection('creators');
    try {
      creators
          .doc(email)
          .set({
        'email': email,
        'username': username,
        'password': password,
        'address': address
      })
          .then((value) => print("User Added"))
          .catchError((error) =>
          print("Failed to add user: $error")

      );
      return Future<bool>.value(true);
    } catch (e) {
      print(e);
    }
    return Future<bool>.value(false);
  }

//MIGHT WANT TO DO EQUIVALENT FOR WHEN PASSWORD STRENGTH IS WEAK
  //Check if email is valid,
  //async function checks if email exists in cloud firestore
  //return a dynamic validation image depending on results
  //return 'email already exists' message if email is found in cloud firestore
  //return null otherwise
  Future<dynamic> _emailValidation(String email) async {
    _validationMsg = null;
    setState(() {});

    _isChecking = true;
    setState(() {});
    try {
      var collectionRef = FirebaseFirestore.instance.collection('creators');
      var doc = await collectionRef.doc(email).get();
      if (doc.exists) _validationMsg = "Email already exists";
      setState(() {});
      return;
    } catch (e) {
      _validationMsg = null;
    }
    _isChecking = false;
    setState(() {});
  }

  Future<bool> registerCreator() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      bool success = await addCreator(); //save values from controllers to firebase
      if (success) {
        return Future<bool>.value(true);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return Future<bool>.value(false);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return Future<bool>.value(false);
      }
    } catch (e) {
      print(e);
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 20),
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
                    child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) _emailValidation(emailController.text);
                        },
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: emailController,
                          onChanged: (text) {
                            print("Email: $text");
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                          //validators, isEmpty, is valid email, is unique email
                          validator: (value) => _validationMsg,
                          //   if (value == null || value.isEmpty) {
                          //     return "Please enter valid email";
                          //   }
                          //
                          //   if(emailAlreadyExists(value)){
                          //     return "Email already exists";
                          //   }
                          //   return null;
                          // }
                        ))),
                //form field for username (optional)
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () async {
                        //register button pressed
                        //check if entries are valid
                      },
                      child: Text('Register'),
                    ))
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          )),
    ]);
  }
}