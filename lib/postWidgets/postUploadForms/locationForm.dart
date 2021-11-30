import 'package:capstone/utilWidgets/placeSuggestionField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LocationForm extends StatefulWidget {
  const LocationForm({Key? key, required this.user}) : super(key: key);
  final user;
  final formType = 'location';//IMPORTANT FOR DECIDING HOW TO PRESENT POST, EACH FORM HAS A POST TYPE
  @override
  LocationFormState createState() {
    return LocationFormState();
  }
}

class LocationFormState extends State<LocationForm> {
  var caption;
  var address;
  var userDoc;//used to get needed information from user's account(username specifically)
  final captionController = TextEditingController();
  final addressController = TextEditingController();
  @override
  void dispose() {
    captionController.dispose();
    addressController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    captionController.addListener(setCaption);
    addressController.addListener(setAddress);
    super.initState();
  }

  //SET METHODS
  //update fields according to controller text vals
  void setCaption() {
    caption = captionController.text;
  }

  void setAddress() {
    address = addressController.text;
  }

  //Add extended creator credentials in doc where docId = email
  Future<bool> addPost() async {
    var userData =  await FirebaseFirestore.instance.collection('creators').doc(widget.user.email).get();
    userDoc = userData;
    CollectionReference userPostCollection =
    FirebaseFirestore.instance.collection('creators').doc(widget.user.email).collection("myposts");
    try {
      // print(userDoc);
      userPostCollection
          .doc()
          .set({
        'email' : widget.user.email,
        'username' : userDoc.data()['username'],//gets the username from the users doc in firebase
        'postType' : widget.formType,
        'timestamp' : DateTime.now(),
        'caption': caption,
        'address': address,
        })
          .then((value) => print("Location post Added"))
          .catchError((error) =>
          print("Failed to add user: $error")

      );
      //place locationPosts in seperate collection for querying proximity in explore page
      CollectionReference locationCollection = FirebaseFirestore.instance.collection('locationPosts');
      locationCollection.doc().set({
        'email' : widget.user.email,
        'username' : userDoc.data()['username'],//gets the username from the users doc in firebase
        'postType' : widget.formType,
        'timestamp' : DateTime.now(),
        'caption': caption,
        'address': address,
      });
      return Future<bool>.value(true);
    } catch (e) {
      print(e);
    }
    return Future<bool>.value(false);
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
                  text: 'Location Post',
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

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: captionController,
                          onChanged: (text) {
                            print("Caption: $text");
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Caption(optional)',
                          ),
                            //no validators currently because caption is optional
                          validator: (value) {
                            // return null;
                          }
                        )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: PlaceSuggestionField(addressController)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          bool success = await addPost();
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Post Successful')),
                            );
                            Navigator.popUntil(context, ModalRoute.withName("userHome"));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error processing data')),
                            );
                          }
                        }
                      },
                      child: Text('Post'),
                    ))
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          )),
    ]);
  }
}