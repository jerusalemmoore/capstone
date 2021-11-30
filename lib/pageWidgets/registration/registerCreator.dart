//Page implementation that presents a form
//to register user to firebase auth and firestore with a creator account
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'creatorRegistrationForm.dart';

//page registration widget for signing up as a Creator
class CreatorRegistrationPage extends StatefulWidget {
  CreatorRegistrationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CreatorRegistrationPageState createState() =>
      _CreatorRegistrationPageState();
}

class _CreatorRegistrationPageState extends State<CreatorRegistrationPage> {
  var currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference creators =
      FirebaseFirestore.instance.collection('creators');

  @override
  Widget build(BuildContext context) {
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
            child: Center(
                child: DraggableScrollableSheet(
                    initialChildSize: 1,
                    expand: true,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CreatorRegistrationForm(),
                          ],
                        ),
                      );
                    }))));
  }
}
