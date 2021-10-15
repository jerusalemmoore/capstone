import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'postForms/captionForm.dart';
class PostPage extends StatefulWidget {
  const PostPage({Key? key, required this.formType}) : super(key: key);
  final String formType;
  @override
  PostPageState createState(){
    return PostPageState();
  }
}

class PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context){
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ConditionalSwitch.single(
                  context: context,
                  valueBuilder: (BuildContext context) => widget.formType,
                  caseBuilders: {
                    'caption' : (BuildContext context) => CaptionForm(),
                    'location' : (BuildContext context) => Text("location form"),
                    'image' : (BuildContext context) => Text('image form'),
                    'video' : (BuildContext context) => Text("video form")
                  },
                  fallbackBuilder: (BuildContext context) => Text("Error")
                )
              ],
            ),
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}