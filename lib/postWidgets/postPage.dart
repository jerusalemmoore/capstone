import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'postUploadForms/captionForm.dart';
import 'postUploadForms/locationForm.dart';
import 'postUploadForms/photoForm.dart';
import 'postUploadForms/videoForm.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key, required this.formType, required this.user})
      : super(key: key);
  final String formType;
  final user;
  @override
  PostPageState createState() {
    return PostPageState();
  }
}

class PostPageState extends State<PostPage> {
  ScrollController? _scrollController;
  @override init(){
    _scrollController  = ScrollController(
    keepScrollOffset: true,
    );
  }
  @override dispose(){
    _scrollController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Post Creation"),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/originals/1a/7a/0c/1a7a0cc45910acf9fac16b292c7034c7.jpg'),
                fit: BoxFit.cover),
          ),
          child: Center(
              child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  expand: true,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ConditionalSwitch.single(
                              context: context,
                              valueBuilder: (BuildContext context) =>
                                  widget.formType,
                              caseBuilders: {
                                'caption': (BuildContext context) =>
                                    CaptionForm(user: widget.user),
                                'location': (BuildContext context) =>
                                    LocationForm(user: widget.user),
                                'image': (BuildContext context) =>
                                    ImageForm(user: widget.user),
                                'video': (BuildContext context) =>
                                    VideoForm(user: widget.user),
                              },
                              fallbackBuilder: (BuildContext context) =>
                                  Text("Error"))
                        ],
                      ),
                    );
                  }))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
