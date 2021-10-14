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

class HomeMainWidgetState extends State<HomeMainWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Container(
            color: Colors.lightBlue,
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Row(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                  child:
                      CircleAvatar(backgroundColor: Colors.blue, radius: 50,
                      child: Text('${widget.user.email[0].toUpperCase()}',
                      style: TextStyle(fontSize: 30) ) ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:20),
                  child: Text("${widget.user.email}",
                      style: TextStyle(fontSize: 20, color:Colors.white))
                )

                //     )
              ])
            ])
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget> [
            //     Expanded(
            //       child: Column(
            //     children: <Widget> [
            //       CircleAvatar(
            //           backgroundColor: Colors.white,
            //           radius:40
            //       )
            //     ]
            // )
            //     ),
            //     Expanded(
            //       child: Text("${widget.user.email}")
            //     )
            //
            //   ]
            // )
            )
      ],
    ));
  }
}
