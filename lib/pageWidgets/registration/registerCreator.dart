//Form in order to register user to firebase auth and firestore with a creator account
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utilWidgets/creatorRegistrationForm.dart';



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
                  initialChildSize:1 ,
                  expand: true,
                  builder: (context, scrollController){
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CreatorRegistrationForm(),
                          // FutureBuilder<DocumentSnapshot>(
                          //   future: creators.doc(currentUser!.email).get(),
                          //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                          //     if(snapshot.hasError){
                          //       return Text('$snapshot.error');
                          //     }
                          //     if(snapshot.hasData && !snapshot.data!.exists){
                          //       return Text("file doesn't exist");
                          //
                          //     }
                          //     if(snapshot.connectionState == ConnectionState.done){
                          //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          //       return Text("Full Name: ${data['email']} ${data['password']}");
                          //     }
                          //     return Text("loading");
                          //   }
                          // )

                          // Text(
                          //   'You have clicked the button this many times:',
                          // ),
                          // Text(
                          //   '$_counter',
                          //   style: Theme.of(context).textTheme.headline4,
                          // ),
                        ],
                      ),
                    );
                  }
                ))));
  }
}
