import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//registration form for a Creator
//fields:
//username
//email
//password
//address (used for proximity to users that are exploring on map or explore page)
class ImageForm extends StatefulWidget {
  const ImageForm({Key? key, required this.user}) : super(key: key);
  final user;
  final formType = 'image';//IMPORTANT FOR DECIDING HOW TO PRESENT POST, EACH FORM HAS A POST TYPE
  @override
  ImageFormState createState() {
    return ImageFormState();
  }
}

//state implementation of Creator form
//Value fields:
// String username;
// String email;
// String password;
// String address;
class ImageFormState extends State<ImageForm> {
  dynamic _pickImageError;
  String? _retrieveDataError;
  var userDoc;//used to get needed information from user's account(username specifically)
  final ImagePicker _picker = ImagePicker();
  var imageFile;
  var caption;
  final captionController = TextEditingController();
  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (imageFile != null) {
      return  Image.file(File(imageFile!.path));

    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }
  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    print("pick image");

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
    // print("nothing happened");
  }
  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    captionController.addListener(setCaption);
    super.initState();
  }

  //SET METHODS
  //update fields according to controller text vals
  void setCaption() {
    caption = captionController.text;
  }

  //Add extended creator credentials in doc where docId = email
  Future<bool> addPost() async {
    bool errorFound = false;
    var userData =  await FirebaseFirestore.instance.collection('creators').doc(widget.user.email).get();
    userDoc = userData;
    CollectionReference userPostCollection =
    FirebaseFirestore.instance.collection('creators').doc(widget.user.email).collection("myposts");

    String fileName = basename(imageFile!.path);//name of new image file
    String baseName = 'creators/${userDoc.data()['username']}/images';
    String filePath = '$baseName/$fileName';
    try{
      await firebase_storage.FirebaseStorage.instance
          .ref('$filePath')
          .putFile(File(imageFile.path));
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }


    try {
      await userPostCollection
          .doc()
          .set({
        'email' : widget.user.email,
        'username' : userDoc.data()['username'],//gets the username from the users doc in firebase
        'postType' : widget.formType,
        'timestamp' : DateTime.now(),
        'caption' : caption,
        'imageFile' : filePath
      })
          .then((value) => print("Caption post added"))
          .catchError((error) =>{
      print("Failed to add user: $error"),
      errorFound = true
      }


      );
    } catch (e) {
      print(e);
    }
    if(errorFound){
      print("Error uploading image post to firebase");
      return false;
    }
    return true;
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
                  text: 'Image Post',
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
                              labelText: 'Caption',
                            ),
                            //validators, isEmpty, is valid email, is unique email
                            validator: (value) {
                              // if (value == null || value.isEmpty) {
                              //   return "Caption is required";
                              // }
                            }

                          //
                          //   if(emailAlreadyExists(value)){
                          //     return "Email already exists";
                          //   }
                          //   return null;
                          // }
                        ))),

                Column(
                  children: <Widget>[
                    TextButton(onPressed: ()  =>_onImageButtonPressed(ImageSource.camera, context:context), child: Text("Take Image")),
                    TextButton(onPressed: ()  =>_onImageButtonPressed(ImageSource.gallery, context:context), child: Text("Upload Image"))
                  ]
                ),
                _previewImages(),
                //form field for username (optional)
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        if(imageFile == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error, no image selected')),
                          );
                        }
                        else{
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            addPost().then((value){
                              if(value == true){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Post Successful')));
                                Navigator.pop(context);
                              }
                              else if(value == false){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Error processing data, try again')),
                                        );
                                }

                            });
                            // if (success) {
                            //
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Post Successful')),
                            //     // Navigator.popUntil(context, ModalRoute.withName("userHome"));
                            //
                            //   );
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Error processing data, try again')),
                            //   );
                            // }
                          }
                          // Navigator.pop(context);

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