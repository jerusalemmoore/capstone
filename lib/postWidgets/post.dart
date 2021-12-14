// post.dart
//
// this is the implementation for how post objects are rendered based on there type
// there are currently 4 types
// caption post
// location post
// image post
// video post

import 'package:capstone/pageWidgets/homeWidgets/homeMain.dart';
import 'package:capstone/pageWidgets/otherUser.dart';
// import 'package:chewie/chewie.dart';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:better_player/better_player.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'postPage.dart';

//conversion for showing users distance to post in miles rather than meters
var meterToMileConversion = .000621371;

//Implementation of caption post as a stateful widget
//args:
//username - posters username
//distFromUser - current distance between posters address and users current location(only posts when on explore)
//caption - content of the caption post
//timestamp - the time the post was sent

class CaptionPost extends StatefulWidget {
  const CaptionPost({
    Key? key,
    this.distFromUser,
    required this.postInfo,
  }) : super(key: key);
  final postInfo;
  final distFromUser;
  @override
  CaptionPostState createState() => CaptionPostState();
}

class CaptionPostState extends State<CaptionPost> {
  late DateTime dt;
  var formattedDate;
  initState() {
    dt = widget.postInfo['timestamp'].toDate();
    formattedDate = DateFormat.yMd().add_jm().format(dt);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        // padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))),
              width: constraints.maxWidth,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          // child: Text('${widget.username}', style: TextStyle(color: Colors.white))
                          child: RichText(
                              text: TextSpan(
                                  style: GoogleFonts.abhayaLibre(
                                      textStyle: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 25,
                                  )),
                                  children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (!(widget.postInfo['email'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.email)) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherUserWidget(
                                                        email: widget.postInfo[
                                                            'email'])));
                                      }
                                    },
                                  text: '${widget.postInfo['username']}',
                                ),
                              ])),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          // child: Text('$formattedDate', style:TextStyle(color:Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '$formattedDate',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ))),
                          ])),
                        ),
                      ])),
            );
          }),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              //   color: Colors.white,
              //   // border: Border(
              //   //   top: BorderSide(color:Colors.black)
              //   // )
              // ),
              width: constraints.maxWidth,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '${widget.postInfo['caption']}',
                              style: GoogleFonts.abhayaLibre(
                                  textStyle: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ))),
                        ]))),
                  ),
                  if (widget.distFromUser != null)
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                                  style: GoogleFonts.abhayaLibre(
                                      textStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ))),
                            ]))))
                ],
              ),
            );
          }),
        ]));
  }
}

//Implementation of location post as a stateful widget
//args:
//username - posters username
//distFromUser - current distance between posters address and users current location(only posts when on explore)
//location - the address of being presented in the post
//caption - caption that may or may not be with location post
//timestamp - the time the post was sent
class LocationPost extends StatefulWidget {
  const LocationPost({
    Key? key,
    this.distFromUser,
    required this.postInfo,
  }) : super(key: key);
  final postInfo;
  final distFromUser;
  @override
  LocationPostState createState() => LocationPostState();
}

class LocationPostState extends State<LocationPost> {
  late DateTime dt;
  var formattedDate;
  initState() {
    dt = widget.postInfo['timestamp'].toDate();
    formattedDate = DateFormat.yMd().add_jm().format(dt);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        // padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          // child: Text('${widget.username}', style: TextStyle(color: Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '${widget.postInfo['username']}',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25,
                                ))),
                          ])),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          // child: Text('$formattedDate', style:TextStyle(color:Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '$formattedDate',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ))),
                          ])),
                        )
                      ])),
            );
          }),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.grey
                      // ),
                      // BoxShadow(
                      //   color: Colors.grey,
                      //   spreadRadius:  -12,
                      //   blurRadius: 12.0
                      // )
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: -5,
                        blurRadius: 5,
                        // offset: Offset(0, -3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black),
                      bottom: BorderSide(color: Colors.black),
                    )),
                width: constraints.maxWidth,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    // child: Text(widget.location),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '${widget.postInfo['address']}',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 25,
                          ))),
                    ]))));
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(15),
                // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.postInfo['caption'] == null
                          ? ''
                          : '${widget.postInfo['caption']}',
                      style: GoogleFonts.abhayaLibre(
                          textStyle: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ))),
                ]))),
          ),
          if (widget.distFromUser != null)
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text:
                              '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ))),
                    ]))))
        ]));
  }
}

class ImagePost extends StatefulWidget {
  const ImagePost({
    Key? key,
    this.distFromUser,
    required this.postInfo,
  }) : super(key: key);
  final postInfo;
  final distFromUser;
  @override
  ImagePostState createState() => ImagePostState();
}

class ImagePostState extends State<ImagePost> {
  late DateTime dt;
  var formattedDate;
  late Image image;
  late var url;
  initState() {
    dt = widget.postInfo['timestamp'].toDate();
    formattedDate = DateFormat.yMd().add_jm().format(dt);
    getDownloadUrl();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getDownloadUrl() async {
    Reference ref =
        FirebaseStorage.instance.ref().child(widget.postInfo['imageFile']);
    var downloadUrl = await ref.getDownloadURL();
    url = downloadUrl.toString();
    // image = Image.network(url);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        // padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          // child: Text('${widget.username}', style: TextStyle(color: Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '${widget.postInfo['username']}',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25,
                                ))),
                          ])),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          // child: Text('$formattedDate', style:TextStyle(color:Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '$formattedDate',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ))),
                          ])),
                        )
                      ])),
              width: constraints.maxWidth,
            );
          }),
          FutureBuilder(
              future: getDownloadUrl(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.grey
                              // ),
                              // BoxShadow(
                              //   color: Colors.grey,
                              //   spreadRadius:  -12,
                              //   blurRadius: 12.0
                              // )
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: -5,
                                blurRadius: 5,
                                // offset: Offset(0, -3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(color: Colors.black),
                              bottom: BorderSide(color: Colors.black),
                            )),
                        width: constraints.maxWidth,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: url,
                            placeholder: (context, url) => Column(
                              children: [
                                Spacer(),
                                CircularProgressIndicator(),
                                Spacer()
                              ]
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                          // ;image,
                        ));
                  });
                } else {
                  return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(child: CircularProgressIndicator()));
                  ;
                }
              }),
          // Text(widget.imagePath),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(15),
                // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.postInfo['caption'] == null
                          ? ''
                          : '${widget.postInfo['caption']}',
                      style: GoogleFonts.abhayaLibre(
                          textStyle: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ))),
                ]))),
          ),
          if (widget.distFromUser != null)
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text:
                              '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ))),
                    ]))))
        ]));
  }
}

class VideoPost extends StatefulWidget {
  const VideoPost({
    Key? key,
    this.distFromUser,
    required this.postInfo,
  }) : super(key: key);
  final postInfo;
  final distFromUser;
  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends State<VideoPost> {
  late DateTime dt;
  var formattedDate;

  //note betterplayer auto disposes
  late BetterPlayerController _betterPlayerController;
  Future<void> getDownloadUrl() async {
    Reference ref =
        FirebaseStorage.instance.ref().child(widget.postInfo['videoFile']);
    var downloadUrl = await ref.getDownloadURL();
    var url = downloadUrl.toString();
    //configure data source with url
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
          minBufferMs: 2000,
          maxBufferMs: 10000,
          bufferForPlaybackMs: 1000,
          bufferForPlaybackAfterRebufferMs: 2000),
    );
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            controlsConfiguration: BetterPlayerControlsConfiguration(
              loadingWidget: CircularProgressIndicator(),
              //while I can't fix fullscreen disable it
              enableFullscreen: false
            ),
            // placeholder: Text("Loading"),
            // showPlaceholderUntilPlay: true,
            handleLifecycle: true,
            autoDispose: true),
        betterPlayerDataSource: dataSource);
  }

  @override
  initState() {
    //format posts date
    dt = widget.postInfo['timestamp'].toDate();
    formattedDate = DateFormat.yMd().add_jm().format(dt);
    // getDownloadUrl();

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        // padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          // child: Text('${widget.username}', style: TextStyle(color: Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '${widget.postInfo['username']}',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25,
                                ))),
                          ])),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          // child: Text('$formattedDate', style:TextStyle(color:Colors.white))
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '$formattedDate',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ))),
                          ])),
                        )
                      ])),
              width: constraints.maxWidth,
              // child: Padding(
              //     padding: EdgeInsets.all(10),
              //     child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Align(
              //               alignment: Alignment.topLeft,
              //               child: Text('${widget.username}')),
              //           Align(
              //               alignment: Alignment.topRight,
              //               child: Text('$formattedDate'))
              //         ])),
            );
          }),
          // Text('${widget.username}'),

          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.grey
                    // ),
                    // BoxShadow(
                    //   color: Colors.grey,
                    //   spreadRadius:  -12,
                    //   blurRadius: 12.0
                    // )
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: -5,
                      blurRadius: 5,
                      // offset: Offset(0, -3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  )),
              width: constraints.maxWidth,
              child: FutureBuilder(
                  future: getDownloadUrl(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: BetterPlayer(
                              controller:
                                  _betterPlayerController));
                    } else {
                      return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Center(child: CircularProgressIndicator()));
                      //   Center(
                      //   child:Column(
                      //       children: [
                      //         CircularProgressIndicator(),
                      //
                      //       ]
                      //   )
                      // ) ;

                    }
                  }),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(15),
                // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.postInfo['caption'] == null
                          ? ''
                          : '${widget.postInfo['caption']}',
                      style: GoogleFonts.abhayaLibre(
                          textStyle: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ))),
                ]))),
          ),
          if (widget.distFromUser != null)
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text:
                              '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ))),
                    ]))))
        ]));
  }
}
