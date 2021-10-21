import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

//registration form for a Creator
//fields:
//username
//email
//password
//address (used for proximity to users that are exploring on map or explore page)
class VideoForm extends StatefulWidget {
  const VideoForm({Key? key, required this.user}) : super(key: key);
  final user;
  final formType = 'video';//IMPORTANT FOR DECIDING HOW TO PRESENT POST, EACH FORM HAS A POST TYPE
  @override
  VideoFormState createState() {
    return VideoFormState();
  }
}

//state implementation of Creator form
//Value fields:
// String username;
// String email;
// String password;
// String address;
class VideoFormState extends State<VideoForm> {
  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  XFile? videoFile;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  var caption;
  final captionController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      controller = VideoPlayerController.file(File(file.path));
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      final double volume = 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }
  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }
  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }
  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    print("pick video");

    try {
      final pickedFile = await _picker.pickVideo(
        source: source,
      );
      await _playVideo(pickedFile);
      setState(() {
        videoFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
    // print("nothing happened");
  }
  @override
  void dispose() {
    _disposeVideoController();
    captionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    captionController.addListener(setCaption);
    super.initState();
  }

  //SET METHODS
  //update fields according to controller text vals
  void setCaption() {
    caption = captionController.text;
  }

  //Add extended creator credentials in doc where docId = email
  Future<bool> addPost() async {
    bool errorFound = false;
    CollectionReference userPostCollection =
    FirebaseFirestore.instance.collection('creators').doc(widget.user.email).collection("myposts");

    Directory appDocDir = await  getApplicationDocumentsDirectory();
    String fileName = basename(videoFile!.path);
    String filePath = '${appDocDir.absolute}/$fileName';
    try{
      await firebase_storage.FirebaseStorage.instance
          .ref('$filePath')
          .putFile(File(videoFile!.path));
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }


    try {
      await userPostCollection
          .doc()
          .set({
        'postType' : widget.formType,
        'timestamp' : DateTime.now(),
        'caption' : caption,
        'videoFile' : filePath
      })
          .then((value) => print("Caption post added"))
          .catchError((error) =>{
        print("Failed to add user: $error"),
        errorFound = true
      }


      );
    } catch (e) {
      print(e);
    }
    if(errorFound){
      print("Error uploading image post to firebase");
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: 'Image Post',
                  style: GoogleFonts.abhayaLibre(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 50,
                      ))),
            ]

              // style: TextStyle(fontFamily: 'RototoMono')
            )),
      ),
      Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Column(
              children: <Widget>[
                //form field for email
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Focus(
                        child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: captionController,
                            onChanged: (text) {
                              print("Caption: $text");
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: 'Caption',
                            ),
                            //validators, isEmpty, is valid email, is unique email
                            validator: (value) {
                              // if (value == null || value.isEmpty) {
                              //   return "Caption is required";
                              // }
                            }

                          //
                          //   if(emailAlreadyExists(value)){
                          //     return "Email already exists";
                          //   }
                          //   return null;
                          // }
                        ))),

                Column(
                    children: <Widget>[
                      TextButton(onPressed: ()  =>_onImageButtonPressed(ImageSource.camera, context:context), child: Text("Take Video")),
                      TextButton(onPressed: ()  =>_onImageButtonPressed(ImageSource.gallery, context:context), child: Text("Upload Video"))
                    ]
                ),
                _previewVideo(),
                //form field for username (optional)
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () async {
                        if(videoFile == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error, no image selected')),
                          );
                        }
                        else{
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            bool success = await addPost();
                            if (success) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Post Successful')),
                              );
                              Navigator.pushNamedAndRemoveUntil(context, "userHome", (r) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error processing data')),
                              );
                            }
                          }
                        }

                      },
                      child: Text('Post'),
                    ))
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          )),
    ]);
  }
}
class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}
class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}