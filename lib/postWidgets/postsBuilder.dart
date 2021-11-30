import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'postRenderer.dart';

class PostsBuilder extends StatefulWidget {
  const PostsBuilder({Key? key, required this.userEmail}) : super(key: key);
  final userEmail;

  @override
  PostsBuilderState createState() => PostsBuilderState();
}

class PostsBuilderState extends State<PostsBuilder> {
  var posts = [];
  @override
  void dispose() {
    super.dispose();
  }
  //testing
  // bool get wantKeepAlive => true;

  Future<void> retrievePosts() async {
    await FirebaseFirestore.instance
        .collection('creators')
        .doc(widget.userEmail)
        .collection('myposts')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //   print("yes");
        // print("yes");
        // print(posts);
        // print(posts.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('creators')
          .doc(widget.userEmail)
          .collection('myposts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print(widget.userEmail);
          print(snapshot);
          if (snapshot.data!.size.toString() == '0') {
            return Center(child: Text("No Posts"));
          }
          else{
            return ListView.builder(
              // cacheExtent: 1000,
                addAutomaticKeepAlives: false,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  List docs = snapshot.data!.docs;
                  return PostRenderer(postData: docs[index]);
                });
          }
        } else {
          return Column(children: <Widget>[
            Spacer(),
            CircularProgressIndicator(),
            Spacer()
          ]);
        }
      },
    );
  }
}
