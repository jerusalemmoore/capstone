import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'post.dart';

//widget builds a post object depending on the type firebase doc info
//types
//caption
//location
//image
//video
//postrenderer requires a document snapshot of the post info from firebase
class ExplorePostRenderer extends StatefulWidget {
  ExplorePostRenderer({Key? key, required this.postData, required this.distFromUser}) : super(key: key);
  final DocumentSnapshot postData;
  final double distFromUser;
  ExplorePostRendererState createState() => ExplorePostRendererState();
}

class ExplorePostRendererState extends State<ExplorePostRenderer> {
  @override
  Widget build(BuildContext context) {
    return ConditionalSwitch.single<dynamic>(
        context: context,
        valueBuilder: (BuildContext context) => widget.postData['postType'],
        caseBuilders: {
          'image': (BuildContext context) {
            // return Text("image post");
            // return Container(
            //   height:50,
            //   child:Center(child: Text('${widget.postData['timestamp']}')),
            // );
            //find a better way to make "" the default val in posts with optional caption

            return ImagePost(
                username: (widget.postData['username']),
                caption: (widget.postData['caption'] == null)
                    ? ""
                    : widget.postData['caption'],
                imagePath: widget.postData['imageFile'],
                timestamp: widget.postData['timestamp'],
              distFromUser: widget.distFromUser,

            );

          },
          'video': (BuildContext context) {
            // return Text("video post");
            // return Container(
            //   height:50,
            //   child:Center(child: Text('${widget.postData['timestamp']}')),
            // );
            return VideoPost(
                username: (widget.postData['username']),
                caption: (widget.postData['caption'] == null)
                    ? ""
                    : widget.postData['caption'],
                videoPath: widget.postData['videoFile'],
                timestamp: widget.postData['timestamp'],
                distFromUser: widget.distFromUser);
          },
          'location': (BuildContext context) {
            // return Text("location post");
            // return Container(
            //   height:50,
            //   child:Center(child: Text('${widget.postData['timestamp']}')),
            // );
            return LocationPost(
                username: (widget.postData['username']),
                caption: (widget.postData['caption'] == null)
                    ? ""
                    : widget.postData['caption'],
                location: widget.postData['address'],
                timestamp: widget.postData['timestamp'],
              distFromUser: widget.distFromUser,
            );
          },
          'caption': (BuildContext context) {
            // return Text("caption post");
            // return Container(
            //   height:50,
            //   child:Center(child: Text('${widget.postData['timestamp']}')),
            // );
            return CaptionPost(
                username: (widget.postData['username']),
                caption: widget.postData['caption'],
                timestamp: widget.postData['timestamp'],
              distFromUser: widget.distFromUser,

            );

          },
        },
        fallbackBuilder: (BuildContext context) =>
            Text("Error, invalid post type"));
  }
}
// Container(
// height:50,
// child:Center(child: Text('${posts[index]['timestamp']}')),
// );
