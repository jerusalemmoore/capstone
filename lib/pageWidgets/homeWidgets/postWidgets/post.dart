import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:better_player/better_player.dart';
import 'package:auto_size_text/auto_size_text.dart';

var meterToMileConversion = .000621371;

class CaptionPost extends StatefulWidget {
  const CaptionPost(
      {Key? key,
      required this.username,
        this.distFromUser,
        required this.caption,
      required this.timestamp})
      : super(key: key);
  final caption;
  final timestamp;
  final username;
  final distFromUser;
  @override
  CaptionPostState createState() => CaptionPostState();
}

class CaptionPostState extends State<CaptionPost> {
  late DateTime dt;
  var formattedDate;
  initState() {
    dt = widget.timestamp.toDate();
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
          ],),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color:Colors.black)
                )
              ),
              width: constraints.maxWidth,
                child:Padding(
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
                                        text: '${widget.username}',
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
                        ]

                    )
                ),

            );
          }),
         LayoutBuilder(
           builder: (BuildContext context, BoxConstraints constraints){
             return Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                 color: Colors.white,
                 // border: Border(
                 //   top: BorderSide(color:Colors.black)
                 // )
               ),
               width: constraints.maxWidth,
               child:Column(
                 children: [
                   Align(
                     alignment: Alignment.centerLeft,
                     child:  Padding(padding: EdgeInsets.all(15),
                         // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                         child:RichText(
                             text: TextSpan(children: [
                               TextSpan(
                                   text: '${widget.caption}',
                                   style: GoogleFonts.abhayaLibre(
                                       textStyle: TextStyle(
                                         // fontWeight: FontWeight.bold,
                                         color: Colors.black,
                                         fontSize: 17,
                                       ))),
                             ]))
                     ),
                   ),
                   if(widget.distFromUser != null)
                   Align(
                       alignment: Alignment.bottomRight,
                     child: Padding(
                       padding: EdgeInsets.all(10),
                         // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                       child:RichText(
                           text: TextSpan(children: [
                             TextSpan(
                                 text: '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                                 style: GoogleFonts.abhayaLibre(
                                     textStyle: TextStyle(
                                       fontStyle: FontStyle.italic,
                                       // fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       fontSize: 13,
                                     ))),
                           ]))
                     )

                   )


                 ],
               ),
             );
           }
         ),


        ]));
  }
}

class LocationPost extends StatefulWidget {
  const LocationPost(
      {Key? key,
      required this.username,
        this.distFromUser,

        this.caption = "",
      required this.timestamp,
      required this.location})
      : super(key: key);
  final caption;
  final distFromUser;
  final timestamp;
  final location;
  final username;
  @override
  LocationPostState createState() => LocationPostState();
}

class LocationPostState extends State<LocationPost> {
  late DateTime dt;
  var formattedDate;
  initState() {
    dt = widget.timestamp.toDate();
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
            ],),

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
                                            text: '${widget.username}',
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
                  return

                    Container(
                        decoration:BoxDecoration(
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
                            )
                        ),
                        width: constraints.maxWidth,

                        child:
                        Padding(
                          padding: EdgeInsets.all(20),
                          // child: Text(widget.location),
                           child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '${widget.location}',
                                      style: GoogleFonts.abhayaLibre(
                                          textStyle: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 25,
                                          ))),
                                ]))
                        )
                    );
                }
            ),

            Align(
              alignment: Alignment.centerLeft,
              child:  Padding(padding: EdgeInsets.all(15),
                // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                  child:RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '${widget.caption}',
                            style: GoogleFonts.abhayaLibre(
                                textStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17,
                                ))),
                      ]))
              ),
            ),
            if(widget.distFromUser != null)
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                      child:RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ))),
                          ]))
                  )

              )


          ]));

  }
}

class ImagePost extends StatefulWidget {
  const ImagePost(
      {Key? key,
      required this.username,
      this.caption = "",
      required this.timestamp,
      this.distFromUser,
      required this.imagePath})
      : super(key: key);
  final caption;
  final timestamp;
  final imagePath;
  final username;
  final distFromUser;
  @override
  ImagePostState createState() => ImagePostState();
}

class ImagePostState extends State<ImagePost> {
  late DateTime dt;
  var formattedDate;
  late Image image;
  initState() {
    dt = widget.timestamp.toDate();
    formattedDate = DateFormat.yMd().add_jm().format(dt);
    getDownloadUrl();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getDownloadUrl() async {
    Reference ref = FirebaseStorage.instance.ref().child(widget.imagePath);
    var downloadUrl = await ref.getDownloadURL();
    var url = downloadUrl.toString();
    image = Image.network(url);
    // BetterPlayerDataSource dataSource = BetterPlayerDataSource(
    //   BetterPlayerDataSourceType.network,
    //   url
    // );
    // _betterPlayerController = BetterPlayerController(
    //   BetterPlayerConfiguration(
    //      autoDispose: false,
    //       autoDetectFullscreenAspectRatio: true,
    //       autoDetectFullscreenDeviceOrientation: true,
    //   ),
    //   betterPlayerDataSource: dataSource
    // );

    // return downloadUrl;
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
          ],),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              child:Padding(
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
                                    text: '${widget.username}',
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
          FutureBuilder(
              future: getDownloadUrl(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        return Container(
                            decoration:BoxDecoration(
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
                                )
                            ),
                            width: constraints.maxWidth,

                            child:
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: image,
                            )
                        );
                      }
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          // Text(widget.imagePath),
          Align(
            alignment: Alignment.centerLeft,
            child:  Padding(padding: EdgeInsets.all(15),
                // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                child:RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${widget.caption}',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17,
                              ))),
                    ]))
            ),
          ),
          if(widget.distFromUser != null)
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                    child:RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                              style: GoogleFonts.abhayaLibre(
                                  textStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ))),
                        ]))
                )

            )

        ]));
  }
}

class VideoPost extends StatefulWidget {
  const VideoPost(
      {Key? key,
      required this.username,
        this.distFromUser,
      this.caption = '',
      required this.timestamp,
      required this.videoPath})
      : super(key: key);
  final caption;
  final distFromUser;
  final timestamp;
  final videoPath;
  final username;
  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends State<VideoPost> {
  late DateTime dt;
  var formattedDate;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late BetterPlayerController _betterPlayerController;
  Future<void> getDownloadUrl() async {
    Reference ref = FirebaseStorage.instance.ref().child(widget.videoPath);
    var downloadUrl = await ref.getDownloadURL();
    var url = downloadUrl.toString();
    videoPlayerController = VideoPlayerController.network(url);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        // looping: true,
        autoInitialize: false);//this might fix the crashing

    // BetterPlayerDataSource dataSource = BetterPlayerDataSource(
    //   BetterPlayerDataSourceType.network,
    //   url
    // );
    // _betterPlayerController = BetterPlayerController(
    //   BetterPlayerConfiguration(
    //      autoDispose: false,
    //       autoDetectFullscreenAspectRatio: true,
    //       autoDetectFullscreenDeviceOrientation: true,
    //   ),
    //   betterPlayerDataSource: dataSource
    // );

    // return downloadUrl;
  }
  @override
  initState() {
    //format posts date
    dt = widget.timestamp.toDate();
    formattedDate = DateFormat.yMd().add_jm().format(dt);
    getDownloadUrl();

    super.initState();
  }
@override
  dispose() {
    // videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  void listener() {
    if (!chewieController.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    // if(chewieController.isFullScreen){
    //   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        // padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
          border:  Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],),
        child: Column(children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  child:Padding(
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
                                        text: '${widget.username}',
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
          FutureBuilder(
              future: getDownloadUrl(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // return AspectRatio(
                  //     aspectRatio: 16 / 9,
                  //     child: Chewie(controller: chewieController));
                  return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                        return Container(
                            decoration:BoxDecoration(
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
                                )
                            ),
                            width: constraints.maxWidth,

                            child:
                            AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Chewie(controller: chewieController))
                        );
                      }
                  );
                  // return SizedBox(
                  //   height: 200,
                  //   child: AspectRatio(aspectRatio: 16/9,
                  //     child: BetterPlayer(
                  //       controller: _betterPlayerController
                  //     )
                  //
                  //   )
                  //   // child: Chewie(
                  //   //     controller: chewieController
                  //   // )
                  // );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          //            Container(
          //     child: Chewie(
          //     controller:chewieController,
          // ),
          // ),
          // VideoPlayerController.network(snapshot);
          Align(
            alignment: Alignment.centerLeft,
            child:  Padding(padding: EdgeInsets.all(15),
                // child:  Text(widget.caption, style: TextStyle(color: Colors.white)),
                child:RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${widget.caption}',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17,
                              ))),
                    ]))
            ),
          ),
          if(widget.distFromUser != null)
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    // child: Text("${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles")
                    child:RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '${(widget.distFromUser * meterToMileConversion).toStringAsFixed(2)} miles',
                              style: GoogleFonts.abhayaLibre(
                                  textStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ))),
                        ]))
                )

            )
        ]));
  }
}
