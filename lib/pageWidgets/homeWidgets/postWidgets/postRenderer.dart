import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'post.dart';
//class that renders a post object depending on the type of post
//types
//caption
//location
//image
//video
//postrenderer requires a document snapshot of the post info from firebase
class PostRenderer extends StatefulWidget{
  PostRenderer({Key? key, required this.postData}) : super(key:key);
  final DocumentSnapshot postData;
  PostRendererState createState() => PostRendererState();
}
class PostRendererState extends State<PostRenderer>{

  @override
  Widget build(BuildContext context){
    return ConditionalSwitch.single<dynamic>(
      context: context,
      valueBuilder: (BuildContext context) => widget.postData['postType'],
      caseBuilders: {
        'image' : (BuildContext context) {
          // return Text("image post");
          // return Container(
          //   height:50,
          //   child:Center(child: Text('${widget.postData['timestamp']}')),
          // );
          //find a better way to make "" the default val in posts with optional caption
          return ImagePost(caption: (widget.postData['caption'] == null) ? "" : widget.postData['caption']  ,imagePath: widget.postData['imageFile'], timestamp: widget.postData['timestamp']);
        },
        'video' : (BuildContext context){
          // return Text("video post");
          // return Container(
          //   height:50,
          //   child:Center(child: Text('${widget.postData['timestamp']}')),
          // );
          return VideoPost(caption:(widget.postData['caption'] == null) ? "" : widget.postData['caption'],videoPath: widget.postData['videoFile'], timestamp: widget.postData['timestamp']);
        },
        'location' : (BuildContext context){
          // return Text("location post");
          // return Container(
          //   height:50,
          //   child:Center(child: Text('${widget.postData['timestamp']}')),
          // );
          return LocationPost(caption: (widget.postData['caption'] == null) ? "" : widget.postData['caption'], location: widget.postData['location'], timestamp: widget.postData['timestamp']);

        },
        'caption' : (BuildContext context){
          // return Text("caption post");
          // return Container(
          //   height:50,
          //   child:Center(child: Text('${widget.postData['timestamp']}')),
          // );
          return CaptionPost(caption: widget.postData['caption'], timestamp: widget.postData['timestamp']);
        },
      },
        fallbackBuilder: (BuildContext context) => Text("Error, invalid post type")
    );
  }
}
// Container(
// height:50,
// child:Center(child: Text('${posts[index]['timestamp']}')),
// );
