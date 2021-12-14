//this widget is for the purpose of showing the current user the
//home page of another user based on clicking their username on posts
import 'package:google_fonts/google_fonts.dart';
import '../../../postWidgets/postsBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class OtherUserWidget extends StatefulWidget {
  const OtherUserWidget({Key? key, required this.email}) : super(key: key);
  final email;

  @override
  OtherUserWidgetState createState() => OtherUserWidgetState();
}

class OtherUserWidgetState extends State<OtherUserWidget> {
  var username;
  var userInfo;
  //get user info using their email in collection 'creators'
  //get other users username
  Future<void> getUserInfo() async {
    // print(widget.email);
    await FirebaseFirestore.instance
        .collection('creators')
        .doc(widget.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      username = snapshot['username'];
    });
  // print(userInfo);
  }

  initState() {
    // getUserInfo();
    super.initState();
  }

  //return a future builder instead
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          //APPBAR TITLE
          title: RichText(
              text: TextSpan(
                  style: GoogleFonts.abhayaLibre(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      )),
                  children: [
                    TextSpan(
                      text: 'Fellow Creator',
                    ),
                  ])),
        ),
      //BACKGROUND IMAGE
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/originals/1a/7a/0c/1a7a0cc45910acf9fac16b292c7034c7.jpg'),
              fit: BoxFit.cover
            )
          ),
          //RETRIEVE USERS INFO AND USE TO PRESENT THEIR POSTS
          child: FutureBuilder(
          future: getUserInfo(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Column(
                  children: <Widget>[
                    //USER PROFILE SECTION
                    Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                              child: CircleAvatar(
                                  backgroundColor: Colors.lightBlueAccent,
                                  foregroundColor: Colors.white,
                                  radius: 50,
                                  child: Text('${username[0].toUpperCase()}',
                                      style: TextStyle(fontSize: 30))),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text("$username",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white))))

                            //     )
                          ])
                        ]),
                        decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 3,
                              spreadRadius: 5)
                        ])),
                    //POSTS LIST
                    Expanded(
                      child: SingleChildScrollView(
                          physics:AlwaysScrollableScrollPhysics(parent:BouncingScrollPhysics()),
                          child: PostsBuilder(userEmail: widget.email)
                      ),
                    )

                    //put posted objects here
                  ],
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        })
        )
      );

  }
}
