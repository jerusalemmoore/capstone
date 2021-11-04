import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../postWidgets/explorePostRenderer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'postRenderer.dart';
import '../mapWidget.dart';
class ExplorePostsBuilder extends StatefulWidget {
  const ExplorePostsBuilder({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  ExplorePostsBuilderState createState() => ExplorePostsBuilderState();
}

class ExplorePostsBuilderState extends State<ExplorePostsBuilder> {
  var posts = [];
  var postsAndDists = [];
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late final currentPosition;
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kLocationServicesDisabledMessage,
      // );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        return false;
      }
    }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   _updatePositionList(
    //     _PositionItemType.log,
    //     _kPermissionDeniedForeverMessage,
    //   );
    //
    //   return false;
    // }
    //
    // // When we reach here, permissions are granted and we can
    // // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );
    return true;
  }

  Future<void> loadPos() async {
    bool permission = await _handlePermission();
    try{
      if (permission) {
        print("success loading pos");
        currentPosition = await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true);
        print("lat ${currentPosition.latitude}");
        print("long ${currentPosition.longitude}");
        return;
        // _center = LatLng(currentPosition.latitude, currentPosition.longitude);
      } else {
        print("failure");
        return;
      }
    } catch (e){
      print(e);
    }

  }
  @override
  void initState(){
    postsAndDists.clear();
    posts.clear();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<List> retrievePosts() async {
  try{
    await loadPos();
    // print('yes');
    // setState((){
    postsAndDists.clear();
    posts.clear();
    // });
    await FirebaseFirestore.instance
        .collection('creators')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc)  async {
        // if(!posts.contains(doc)){
        // setState((){
        // try{

        //
        // }
        // catch(e){
        //   print(e);
        // }
        //
        // var postWithDist = [distanceFromUser, doc];
        // print(doc['username']);
        // print(doc['address']);
        // print(distanceFromUser);

         posts.add(doc);
        // print(doc);
        // });

        // Placemark place = doc.data()![;
        //   print("yes");
        // }
        // print("yes");
        // print(posts);
        // print(posts.length);
      });
    });
  } catch (e){
    print("Error: $e");
  }

    print('size of ${posts.length}');
    for(int i = 0; i < posts.length; i++){
      List<Location> locationInfo = await locationFromAddress(posts[i]['address']);
      double distanceFromUser = Geolocator
          .distanceBetween(currentPosition.latitude, currentPosition.longitude, locationInfo[0].latitude,locationInfo[0].longitude);
      var postWithDistToUser = [distanceFromUser,posts[i]];
      postsAndDists.add(postWithDistToUser);
      // print(posts[i]);
    }
    postsAndDists.sort((a,b){
      // print('yes');
      // print('${a}');
      // print('${b}');
      return a[0].compareTo(b[0]);
    });
    for(int i = 0; i < postsAndDists.length; i++){
      print(i);
    }
    // posts.sort()
    return postsAndDists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: retrievePosts(),
      builder:  (BuildContext context,  AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          // query example to get documents address field from postsAndDists snapshot: snapshot.data[index][1].data()['address']
          // return Text('${snapshot.data[index][1].data()['address']}');
          return ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
                itemBuilder:(context, index1){
                  // query example to get documents address field from postsAndDists snapshot: snapshot.data[index][1].data()['address']
                  // var userPosts = snapshot.data[index][1].get().collection('myposts');
              // return Text('${snapshot.data[index][1].data()['address']}');
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('creators')
                        .doc(snapshot.data[index1][1].data()['email'])
                        .collection('myposts')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> postsSnapshot) {
                      var collectionInstance = postsSnapshot.data;
                      if (collectionInstance == null) {
                        return SizedBox.shrink();
                      }
                      else {
                        // if(!(postsSnapshot.data!.size.toString() == '0')){
                        return ListView.builder(
                            shrinkWrap: true,
                            addAutomaticKeepAlives: false,

                            physics: NeverScrollableScrollPhysics(),

                            itemCount: postsSnapshot.data!.size,
                            itemBuilder: (context, index2) {
                              List docs = postsSnapshot.data!.docs;
                              return ExplorePostRenderer(postData: docs[index2],
                                  distFromUser: snapshot.data[index1][0]);
                            }
                        );
                        // }

                        // else{
                        //   return Text("yes");
                        // }
                      }
                    } );
          }
          );
          return Text('no');
        }
        else{
          // print(snapshot);
          return Column(children: <Widget>[
            Spacer(),
            CircularProgressIndicator(),
            Spacer()
          ]);
        }
    },

    );
    //   StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance
    //       .collection('creators')
    //       .doc(widget.user.email)
    //       .collection('myposts')
    //       .orderBy('timestamp', descending: true)
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasData) {
    //       // return ListView.builder(
    //       //   itemCount: posts.length,
    //       //     itemBuilder: (BuildContext context, int index){
    //       //       // return Container(
    //       //       //   height:50,
    //       //       //   child:Center(child: Text('${posts[index]['timestamp']}')),
    //       //       // );
    //       //       return PostRenderer(postData: posts[index]);
    //       //     }
    //       // );
    //       if (snapshot.data!.size.toString() == '0') {
    //         return Center(child: Text("No Posts"));
    //       }
    //       return ListView.builder(
    //           itemCount: snapshot.data!.size,
    //           itemBuilder: (context, index) {
    //             List docs = snapshot.data!.docs;
    //             return PostRenderer(postData: docs[index]);
    //           });
    //       // return ListView(
    //       //
    //       //   addAutomaticKeepAlives: false,
    //       //     children: snapshot.data!.docs.map((DocumentSnapshot document){
    //       //       Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //       //       // return ListTile(
    //       //       //     title: Text('${data['timestamp']}'),
    //       //       //     subtitle: Text('${data['caption']}')
    //       //       // );
    //       //       return PostRenderer(postData: document);
    //       //     }).toList(),
    //       // );
    //
    //     } else {
    //       return Column(children: <Widget>[
    //         Spacer(),
    //         CircularProgressIndicator(),
    //         Spacer()
    //       ]);
    //     }
    //   },
    // );
  }
}
