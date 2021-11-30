//Implementation of page including a google map that presents location
//posts provided by creator type users
import 'dart:async';
import 'package:capstone/pageWidgets/otherUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const kGoogleApiKey = "AIzaSyAnv3Mv89UoA9m4Jiw9jxeCyVoVDKg9M9w";

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  MapWidgetState createState() {
    return MapWidgetState();
  }
}

class MapWidgetState extends State<MapWidget> with AutomaticKeepAliveClientMixin<MapWidget>{
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  var markerInfo = [];
  var docs = [];
  List<Marker> markers = [];
  late Position currentPosition;
  late GoogleMapController mapController;
  late LatLng _center;

  // static const String _kLocationServicesDisabledMessage =
  //     'Location services are disabled.';
  // static const String _kPermissionDeniedMessage = 'Permission denied.';
  // static const String _kPermissionDeniedForeverMessage =
  //     'Permission denied forever.';
  // static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {

    CollectionReference locationPostsReference = FirebaseFirestore.instance.collection('locationPosts');
    locationPostsReference.snapshots().listen((querySnapshot){
      querySnapshot.docs.forEach((doc) async {
        print(doc['address']);
          MarkerId markerId = MarkerId(doc.id.toString());
          List<Location> locationInfo =
              await locationFromAddress(doc['address']);
          print(locationInfo[0]);
          Marker marker = Marker(
              markerId: markerId,
              position: LatLng(
                  locationInfo[0].latitude, locationInfo[0].longitude),
              infoWindow: InfoWindow(
                title: doc['username'],
                snippet: doc['caption'],
                onTap: (){
                  print('marker tapped');
                  print(doc['username']);
                  print(doc['email']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtherUserWidget(email: doc['email'])),
                  );
                }
              ));
          markers.add(marker);
      });
      print("Marker list: $markers");

    });
    super.initState();

  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print('service not enabled');
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
        print('permission denied');
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

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );
      print('permission denied forever');
      return false;
    }
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
    if (permission) {
      // print("success loading pos");
      currentPosition = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true);
      print("lat ${currentPosition.latitude}");
      print("long ${currentPosition.longitude}");
      _center = LatLng(currentPosition.latitude, currentPosition.longitude);
    }
    else {
      // print("failure");
      _center = LatLng(39.7332194472,-121.825863414);
    }


  // print('center $_center');
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
        future: loadPos(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // print(snapshot.data[0]);
            return  GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 15),
                markers: markers.toSet());
          } else if (snapshot.hasError) {
            return Text("Error");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
        );
    Column(
      children: <Widget>[Text("$currentPosition")],
    );
  }
}
