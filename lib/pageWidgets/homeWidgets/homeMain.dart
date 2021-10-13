import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class HomeMainWidget extends StatefulWidget{
  const HomeMainWidget({Key? key, required this.user}) : super(key:key);
  final user;

  @override
   HomeMainWidgetState createState() => HomeMainWidgetState();
}

class HomeMainWidgetState extends State<HomeMainWidget>{

  @override
  Widget build(BuildContext context){
    return Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.lightBlue,
                      height:  200,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget> [
                          Expanded(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                                radius:40
                            )
                          ),
                          Expanded(
                            child: Text("${widget.user.email}")
                          )

                        ]
                      )
                    )
                  ],
                )
            );


  }
}