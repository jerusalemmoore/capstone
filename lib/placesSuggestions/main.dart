import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: HomePage(),
        ),
      ),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  var uuid= new Uuid();
  // String _sessionToken = new Uuid();
  List<dynamic>_placeList = [];
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (text){

      },
      autocorrect: false,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: "seek location here",
        focusColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(
            Icons.map
        ),
        // suffixIcon: IconButton(
        //   icon: Icon(Icons.cancel),
        //   onPressed:
        // ),
      ),
    );
  }
}