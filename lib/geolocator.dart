import 'dart:async';
import 'dart:math';
import 'package:location/location.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
//CURRENTLY WIDGET IS CALLED TESTWIDGET, MIGHT WANT TO CHANGE NAME TO GEOLOCATOR
const kGoogleApiKey = "AIzaSyAnv3Mv89UoA9m4Jiw9jxeCyVoVDKg9M9w";

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  TestWidgetState createState() {
    return TestWidgetState();
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

class TestWidgetState extends State<TestWidget> {
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  late Position currentPosition;
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handlePermission();
  //
  //   if (!hasPermission) {
  //     return;
  //   }
  //
  //   final position = await _geolocatorPlatform.getCurrentPosition();
  //   _currentPosition = _geolocatorPlatform.getCurrentPosition();
  //   _updatePositionList(
  //     _PositionItemType.position,
  //     position.toString(),
  //   );
  // }

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
  Future<void> loadPos() async{
    bool permission = await _handlePermission();
    if(permission){
       currentPosition = await Geolocator.getCurrentPosition();
    }
    else{

      return;
    }
  }
  // void _updatePositionList(_PositionItemType type, String displayValue) {
  //   _positionItems.add(_PositionItem(type, displayValue));
  //   setState(() {});
  // }

  @override
  void initState(){
    super.initState();
    loadPos();
    // await _handlePermission();
    // currentPosition = await loadPos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadPos(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Text("$currentPosition");
        }
        else if(snapshot.hasError){
          return Text("Error");
        }
        else{
          return CircularProgressIndicator();
        }
      }
    );Column(
      children: <Widget>[
        Text("$currentPosition")
      ],
    );
  }
}

main() {
  runApp(MyApp());
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _MyAppState extends State<MyApp> {
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: <Widget>[
          TestWidget(),
        ]
      )
    );
  }
}
