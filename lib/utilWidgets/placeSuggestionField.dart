//This is a simple widget that produces location suggestions as user types into form field
//requires a controller that will be used for form field
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class PlaceSuggestionField extends StatefulWidget {
  final TextEditingController addressController;
  const PlaceSuggestionField(this.addressController, {Key? key})
      : super(key: key);

  @override
  PlaceSuggestionFieldState createState() {
    return PlaceSuggestionFieldState();
  }
}

class PlaceSuggestionFieldState extends State<PlaceSuggestionField> {
  String? apiKey = 'AIzaSyA8Xbu1XqgRojK9auDk7QDmsWB64HiuEyo';
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];//list to hold suggestions
  @override
  void initState() {
    googlePlace = GooglePlace(apiKey!);//initialize google places with api key
    super.initState();
  }

  //currently checks to make sure whatever is in form field is
  //in the list of address suggestions
  bool addressVerified(String address) {
    for (var i = 0; i < predictions.length; i++) {
      if (predictions[i].description == address) {
        return true;
      }
    }
    return false;
  }
  //take value from input and add suggestions depending on value
  void autoCompleteSearch(String value) async {
    // print("nothing");
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            // margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                    controller: widget.addressController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else {
                        if (predictions.length > 0 && mounted) {
                          setState(() {
                            predictions = [];
                          });
                        }
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "An Address is required";
                      } else if (!addressVerified(value)) {
                        return "Please enter a valid Address";
                      }
                      return null;
                    }),
                SizedBox(
                  height: 10,
                ),
                // Expanded(
                //   child:
                //print size of this list to make sure all suggestions show up
                SingleChildScrollView(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 4)),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                                predictions[index].description ?? "Nothing"),
                            onTap: () {
                              widget.addressController.text =
                                  predictions[index].description!;
                              //empty predictions since user selected address
                              // setState(() {
                              //   predictions.clear();
                              //
                              // });
                            },
                          ));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
