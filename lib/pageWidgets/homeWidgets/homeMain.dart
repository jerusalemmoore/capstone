//Implementation of page that presents current users home page
//includes user info bar and their posts
import '../../../postWidgets/postsBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class HomeMainWidget extends StatefulWidget {
  const HomeMainWidget({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  HomeMainWidgetState createState() => HomeMainWidgetState();
}

class HomeMainWidgetState extends State<HomeMainWidget> with AutomaticKeepAliveClientMixin<HomeMainWidget> {
  var username;
  final aboutController= TextEditingController();
  String? aboutString;
  FocusNode focusNode = FocusNode();
  @override
  bool get wantKeepAlive => true;

  Future<void> getUserInfo() async {
    await FirebaseFirestore.instance
        .collection('creators')
        .doc(widget.user.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      username = snapshot['username'];
      aboutString = snapshot['about'];
      if(aboutString != null){
        aboutController.text = aboutString!;
      }

    });
  }
  Future<void> saveAboutInfo(String newAboutString) async{
    await FirebaseFirestore.instance.collection('creators')
        .doc(widget.user.email)
        .set({
      'about' : newAboutString
    }, SetOptions(merge:true));
  }
  @override
  initState() {
    // getUserInfo();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    aboutController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: getUserInfo(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Column(
              children: <Widget>[
                // user profile section
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
                            child: Column(
                              children:[
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20,20,0,10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                        child:Text("$username",
                                            style: TextStyle(
                                                fontSize: 20, color: Colors.white))
                                    )
            ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child:TextFormField(
                                    style: TextStyle(
                                      fontSize: 15, color: Colors.white
                                    ),
                                    focusNode: focusNode,
                                    // initialValue: aboutString == null? '' : aboutString,
                                    textInputAction: TextInputAction.done,
                                    controller: aboutController,
                                    onTap: () {
                                      //this will save input from about form when user taps text box to unfocus
                                      if(focusNode.hasFocus){
                                        focusNode.unfocus();
                                        saveAboutInfo(aboutController.text);

                                      }
                                    },
                                      //this will save input from about form when user taps enter on keyboard
                                      onFieldSubmitted: (value){
                                      saveAboutInfo(value);
                                      },
                                    maxLines:3,
                                      keyboardType: TextInputType.multiline,
                                      decoration:  InputDecoration(
                                        hintText:  "Include info you'd like others to know about you here",
                                        enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color:Colors.blue, width: 1.0),),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                                        ),
                                      )
                                  )
                                )
                              ]

                            )
          )

                      ])
                    ]),
                    decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 3,
                          spreadRadius: 5)
                    ])),
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    physics:AlwaysScrollableScrollPhysics(parent:BouncingScrollPhysics()),
                        child: PostsBuilder(userEmail: widget.user.email)
                      ),
                )
              ],
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
