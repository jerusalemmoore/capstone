import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utilWidgets/placeSuggestionField.dart';
//look up formbloc plugin for implementing asynchronous validators
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
//Value fields:
// String username;
// String email;
// String password;
// String address;
class RegistrationFormState extends State<CreatorRegistrationForm> {
  dynamic _validationMsg;
  var exists;
  bool _isChecking = false;
  var username;
  var email;
  var password;
  var address;
  var userDoc;
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
    try{

      userDoc = creators
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
    } catch (e){
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
  Future<bool> usernameExists() async{
    var collection = await FirebaseFirestore.instance.collection('creators').
    get()
    .then((QuerySnapshot snapshot){
      snapshot.docs.forEach((doc){
        if(doc['username'] == username){
          setState(() {
            exists = true;
          });

        }
        else{
          setState((){
            exists = false;
          });
        }
    });
    });
    if(exists){
      return Future<bool>.value(true);
    }
    else{
      return Future<bool>.value(false);
    }
    // var doc = await collection.doc(email).get();
    // if(doc.exists){
    //   return true;
    // }
    // else {
    //   return false;
    // }
  }
  //register creator with firebase, return false on error
  Future<bool> registerCreator() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      bool success = await addCreator();//save values from controllers to firebase
      if(success){
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
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
      //registration form
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                                return "Email cannot be empty";
                            }
                            return _validationMsg;
                          },
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
                    child: TextFormField(
                        controller: usernameController,
                        onChanged: (text) {
                          print("Username: $text");
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                        //validators, is unique
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            //if empty, this is ok
                            return "Username cannot be empty";
                          }
                          return null;
                        })),
                //form field for password
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (text) {
                          print("Password: $text");
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        //validators isEmpty, is certain length, numbers and letters
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid password";
                          }
                          return null;
                        })),
                //form field for address
                Padding(
                    padding: EdgeInsets.all(10),
                    child: PlaceSuggestionField(addressController)
                  // TextFormField(
                  //     controller: addressController,
                  //     onChanged: (text) {
                  //       print("Address: $text");
                  //     },
                  //     decoration: InputDecoration(
                  //       fillColor: Colors.white,
                  //       filled: true,
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Address',
                  //     ),
                  //     //validators, isEmpty, is valid address
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return "Please enter valid address";
                  //       }
                  //       return null;
                  //     })
                ),
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
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          //diagnostic prints to make sure we get expected vals
                          // print('email: $email');
                          // print('username: $username');
                          // print('password: $password');
                          // print('address: $address');
                          //attempt to register to firebase auth and firestore
                          bool exists = await usernameExists();
                          if(exists){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error, username is taken')),
                            );
                          } else{
                            bool success = await registerCreator();
                            if (success) {
                              FirebaseAuth.instance
                                  .idTokenChanges()
                                  .listen((User? user) {
                                if (user == null) {
                                  print('User is currently signed out!');
                                } else {
                                  print('User is signed in!');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('User signing in')),

                                  );
                                  Navigator.pushNamed(
                                      context, 'userHome'
                                  );
                                  //NAVIGATE TO HOME SCREEN WIDGET HERE
                                }
                              });
                              // addCreator();
                            }

                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error processing data')),
                              );
                            }
                          }

                        }
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