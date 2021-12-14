import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'explorePostRenderer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'postRenderer.dart';
import '../pageWidgets/homeWidgets/mapWidget.dart';

class ExplorePostsBuilder extends StatefulWidget {
  const ExplorePostsBuilder({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  ExplorePostsBuilderState createState() => ExplorePostsBuilderState();
}

class ExplorePostsBuilderState extends State<ExplorePostsBuilder> with
AutomaticKeepAliveClientMixin<ExplorePostsBuilder>{
  var posts = [];
  var locationPosts = [];
  var usersLocationsAndDists = [];
  var locationsAndDists = [];
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
    try {
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
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    usersLocationsAndDists.clear();
    posts.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List> retrievePosts() async {
    try {
      await loadPos();
      // print('yes');
      // setState((){
      // locationPosts.clear();
      usersLocationsAndDists.clear();
      posts.clear();
      // });
      await FirebaseFirestore.instance
          .collection('creators')
          .get()
          .then((QuerySnapshot users) {
        users.docs.forEach((doc) {
          //test to see if this works without async
          if (doc['email'] != widget.user.email) {
            posts.add(doc);
          }
        });
      });


      await FirebaseFirestore.instance
      .collection('locationPosts')
      .get()
      .then((QuerySnapshot locations) {
        locations.docs.forEach((doc)  {
          if(doc['email'] != widget.user.email){
            // print("location: $doc\n");
            posts.add(doc);
          }
        });
      });

      for (int i = 0; i < posts.length; i++) {
        List<Location> locationInfo =
        await locationFromAddress(posts[i]['address']);
        double distanceFromUser = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            locationInfo[0].latitude,
            locationInfo[0].longitude);
        var postWithDistToUser = [distanceFromUser, posts[i]];
        usersLocationsAndDists.add(postWithDistToUser);
        // print(posts[i]);
        usersLocationsAndDists.sort((a, b) {
          // print('yes');
          // print('${a}');
          // print('${b}');
          return a[0].compareTo(b[0]);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
    return usersLocationsAndDists;
  }
  bool get wantKeepAlive=> true;//this was for keepalive, might be pointless

  @override
  Widget build(BuildContext context) {
    super.build(context);//this was for keepalive, might be pointless
    return FutureBuilder<List>(
      future: retrievePosts(), //get all userdocs
      //usersAndDists is a list of lists holding distance to user in index 0 and
      //the user doc in index 1
      builder: (BuildContext context, AsyncSnapshot usersAndDists) {
        if (usersAndDists.connectionState == ConnectionState.done) {
          // print(usersAndDists.data);
          // query example to get documents address field from postsAndDists snapshot: snapshot.data[index][1].data()['address']
          // return Text('${snapshot.data[index][1].data()['address']}');
          return ListView.builder(
              //view builder to display info form each users doc
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: usersAndDists.data!.length, //number of users
              itemBuilder: (context, userIter) {
                // query example to get documents address field from postsAndDists snapshot: snapshot.data[index][1].data()['address']
                // var userPosts = snapshot.data[index][1].get().collection('myposts');
                // return Text('${snapshot.data[index][1].data()['address']}');
                //for each user doc get their collection of posts
                print('${usersAndDists.data[userIter][1].data()['postType']}\n');
                print('${(usersAndDists.data[userIter][1].data()['postType']).runtimeType}\n');
                if(usersAndDists.data[userIter][1].data()['postType'] == (null)){
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('creators')
                          .doc(usersAndDists.data[userIter][1].data()['email'])
                          .collection('myposts')
                          .orderBy(
                        'timestamp',
                        descending: true,
                      )
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> postsSnapshot) {
                        var collectionInstance = postsSnapshot.data;
                        if (collectionInstance == null) {
                          return SizedBox.shrink();
                        } else {
                          return ListView.builder(
                            // itemExtent: 3,
                            //   cacheExtent: 1000,
                              shrinkWrap: true,
                              addAutomaticKeepAlives: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: postsSnapshot.data!.size,
                              itemBuilder: (context, index2) {
                                List docs = postsSnapshot.data!.docs;
                                if (docs[index2].data()['postType'] !=
                                    'location') {
                                  // print('yes');
                                  // print('${docs[index2]}\n');
                                  return ExplorePostRenderer(
                                      postData: docs[index2],
                                      distFromUser: usersAndDists.data[userIter]
                                      [0]);
                                } else {
                                  // print("locatino post");
                                  // print(docs[index2].data);
                                  return SizedBox.shrink();
                                }

                              });
                        }
                      });
                }
                else{
                  // return Text("location");
                  // print('other list ${usersAndDists.data[userIter][1]}');
                  return ExplorePostRenderer(
                    postData: usersAndDists.data[userIter][1],
                    distFromUser: usersAndDists.data[userIter][0]
                  );
                }

              });
        } else {
          // print(snapshot);
          return CircularProgressIndicator();
          //   Column(children: <Widget>[
          //   Spacer(),
          //   CircularProgressIndicator(),
          //   Spacer()
          // ]);
        }
      },
    );
  }
}
