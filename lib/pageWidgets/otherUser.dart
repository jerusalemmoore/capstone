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
  const OtherUserWidget({Key? key, required this.userEmail}) : super(key: key);
  final userEmail;

  @override
  OtherUserWidgetState createState() => OtherUserWidgetState();
}

class OtherUserWidgetState extends State<OtherUserWidget> {
  // var username;
  var userInfo;
  //get user info using their email in collection 'creators'
  //get other users username
  Future<void> getUserInfo() async {
    // print(widget.email);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // print(widget.email);
    userInfo = await FirebaseFirestore.instance
        .collection('creators')
        .doc(widget.userEmail)
        .get();
    //     .then((DocumentSnapshot snapshot) {
    //   username = snapshot['username'];
    // }
    // );
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
                              padding: EdgeInsets.fromLTRB(10,0 , 20, 0),
                              child: CircleAvatar(
                                  backgroundColor: Colors.lightBlueAccent,
                                  foregroundColor: Colors.white,
                                  radius: 50,
                                  child: Text('${userInfo['username'][0].toUpperCase()}',
                                      style: TextStyle(fontSize: 30))),
                            ),
                            Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(20,20,0,10),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:Text("${userInfo['username']}",
                                                style: TextStyle(
                                                    fontSize: 20, color: Colors.white))
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: TextFormField(
                                            cursorColor: Colors.white,
                                            style: TextStyle(
                                                fontSize: 15, color: Colors.white
                                            ),
                                            // enabled: false,
                                            initialValue: userInfo['about'] == null? '' : userInfo['about'],



                                            //this will save input from about form when user taps enter on keyboard
                                            readOnly: true,
                                            maxLines:3,
                                            keyboardType: TextInputType.multiline,
                                            decoration:  InputDecoration(
                                              hintText:  "Include info you'd like others to know about you here",
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color:Colors.blue, width: 1.0),),


                                            )
                                        )
                                        // TextFormField(
                                        //     cursorColor: Colors.white,
                                        //     style: TextStyle(
                                        //         fontSize: 15, color: Colors.white
                                        //     ),
                                        //     focusNode: focusNode,
                                        //     // initialValue: aboutString == null? '' : aboutString,
                                        //     textInputAction: TextInputAction.done,
                                        //     controller: aboutController,
                                        //     onTap: () {
                                        //       //this will save input from about form when user taps text box to unfocus
                                        //       if(focusNode.hasFocus){
                                        //         focusNode.unfocus();
                                        //         saveAboutInfo(aboutController.text);
                                        //
                                        //       }
                                        //     },
                                        //     //this will save input from about form when user taps enter on keyboard
                                        //     onFieldSubmitted: (value){
                                        //       saveAboutInfo(value);
                                        //     },
                                        //     maxLines:3,
                                        //     keyboardType: TextInputType.multiline,
                                        //     decoration:  InputDecoration(
                                        //       hintText:  "Include info you'd like others to know about you here",
                                        //       enabledBorder: OutlineInputBorder(
                                        //         borderSide: BorderSide(color:Colors.blue, width: 1.0),),
                                        //
                                        //       focusedBorder: OutlineInputBorder(
                                        //         borderSide: BorderSide(color: Colors.white, width: 2.0),
                                        //       ),
                                        //     )
                                        // )
                                    )
                                  ]
                                ))
                                // Padding(
                                //     padding: EdgeInsets.only(bottom: 20),
                                //     child: Text("$username",
                                //         style: TextStyle(
                                //             fontSize: 20, color: Colors.white))))

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
                          child: PostsBuilder(userEmail: userInfo['email'])
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
