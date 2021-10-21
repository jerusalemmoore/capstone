import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CaptionPost extends StatefulWidget{
  const CaptionPost({Key? key, required this.caption, required this.timestamp}) : super(key: key);
  final caption;
  final timestamp;

  @override
  CaptionPostState createState() => CaptionPostState();
}
class CaptionPostState extends State<CaptionPost>{

  @override
  Widget build(BuildContext context){
    return Container(
        margin: const EdgeInsets.all(15.0),

        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent)
        ),
      child: Column(
        children: [
          Text(widget.caption),
          Text('${widget.timestamp}')
        ]
      )

    );

  }
}

class LocationPost extends StatefulWidget{
  const LocationPost({Key? key, this.caption = "", required this.timestamp, required this.location}) : super(key: key);
  final caption;
  final timestamp;
  final location;
  @override
  LocationPostState createState() => LocationPostState();
}
class LocationPostState extends State<LocationPost>{

  @override
  Widget build(BuildContext context){
    return Container(
        margin: const EdgeInsets.all(15.0),

        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent)
        ),
        child: Column(
            children: [
              Text(widget.caption),
              Text(widget.location),
              Text('${widget.timestamp}')
            ]
        )

    );

  }
}

class ImagePost extends StatefulWidget{
  const ImagePost({Key? key, this.caption = "", required this.timestamp, required this.imagePath}) : super(key: key);
  final caption;
  final timestamp;
  final imagePath;
  @override
  ImagePostState createState() => ImagePostState();
}
class ImagePostState extends State<ImagePost>{

  @override
  Widget build(BuildContext context){
    return Container(
        margin: const EdgeInsets.all(15.0),

        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent)
        ),
        child: Column(
            children: [
              Text(widget.caption),
              Text(widget.imagePath),
              Text('${widget.timestamp}')
            ]
        )

    );

  }
}

class VideoPost extends StatefulWidget{
  const VideoPost({Key? key, this.caption = '', required this.timestamp, required this.videoPath}) : super(key: key);
  final caption;
  final timestamp;
  final videoPath;
  @override
  VideoPostState createState() => VideoPostState();
}
class VideoPostState extends State<VideoPost>{

  @override
  Widget build(BuildContext context){
    return Container(
        margin: const EdgeInsets.all(15.0),

        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent)
        ),
        child: Column(

            children: [
              Text('${widget.caption}'),
              Text(widget.videoPath),
              Text('${widget.timestamp}')
            ]
        )

    );

  }
}