import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'postRenderer.dart';

class PostsBuilder extends StatefulWidget {
  const PostsBuilder({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  PostsBuilderState createState() => PostsBuilderState();
}

class PostsBuilderState extends State<PostsBuilder> {
  var posts = [];


  Future<void> retrievePosts() async {
    // setState((){
    //   posts.clear();
    // });
    await FirebaseFirestore.instance
        .collection('creators')
        .doc(widget.user.email)
        .collection('myposts')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // if(!posts.contains(doc)){
        //   // posts.add(doc);
        //   print("yes");
        // }
        print("yes");
        print(posts);
        // print(posts.length);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
      stream:  FirebaseFirestore.instance
          .collection('creators')
          .doc(widget.user.email)
          .collection('myposts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(snapshot.hasData){
        // return ListView.builder(
        //   itemCount: posts.length,
        //     itemBuilder: (BuildContext context, int index){
        //       // return Container(
        //       //   height:50,
        //       //   child:Center(child: Text('${posts[index]['timestamp']}')),
        //       // );
        //       return PostRenderer(postData: posts[index]);
        //     }
        // );
        if(snapshot.data!.size.toString() == '0'){
          return Center(
            child: Text("No Posts")
          );
        }
        return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document){
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              // return ListTile(
              //     title: Text('${data['timestamp']}'),
              //     subtitle: Text('${data['caption']}')
              // );
              return PostRenderer(postData: document);
            }).toList(),
        );

      }
      else{
        return Column(
          children: <Widget>[
            Spacer(),
            CircularProgressIndicator(),
            Spacer()
          ]
        );
      }
    },

    );
  }
}
