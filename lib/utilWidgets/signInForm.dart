import 'package:capstone/pageWidgets/registration/registerCreator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  var email;
  var password;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();

  }
  @override
  void initState(){
    emailController.addListener(setEmail);
    passwordController.addListener(setPassword);
    super.initState();
  }
  void setEmail() {
    email = emailController.text;
  }

  void setPassword() {
    password = passwordController.text;
  }
  Future<bool> signInCreator() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Future<bool>.value(true);
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
    print("success");
    return Future<bool>.value(false);
  }

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
                        controller:emailController,
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
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (text){
                          print("$password");
                          print(text);
                        },
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
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                        bool success = await signInCreator();
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

                              //NAVIGATE TO HOME SCREEN WIDGET HERE
                            }
                          });
                          // addCreator();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error processing data')),
                          );
                        }
                      },
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