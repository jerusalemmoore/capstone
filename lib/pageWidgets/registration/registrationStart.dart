//This widget provides user with choice of creating either a creator account or a patron account
//Patron accounts are somewhat reduntant to creators and will therefore be a version 2 feature
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}


//presents two buttons for user to choose from
//the choice effects how whether the user is registered as a
//creator or a patron
class UserChoiceButtons extends StatefulWidget {
  const UserChoiceButtons({Key? key}) : super(key: key);

  @override
  UserChoiceButtonsState createState() {
    return UserChoiceButtonsState();
  }
}
//state implementation of userchoicebuttons widget
//two choices, Creator and Patron
class UserChoiceButtonsState extends State<UserChoiceButtons> {
  final userChoiceButtonsKey = GlobalKey<UserChoiceButtonsState>();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'Who are you?',
            style: GoogleFonts.abhayaLibre(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 50,
            ))),
      ]

              // style: TextStyle(fontFamily: 'RototoMono')
              )),
      //CREATOR CARD
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            //navigate to creator registration
            Navigator.pushNamed(
                context, 'creatorRegistration');
            // print('Card tapped.');
          },
          child: SizedBox(
              width: 300,
              height: 100,
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                      child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Creator',
                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 25,
                                    ))),
                          ]
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: RichText(
                          textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Show your work to patrons/creators near you through posts',

                                style: GoogleFonts.abhayaLibre(
                                    textStyle: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    )))
                        )
                    )
                  ])),
        ),
      ),
      //PATRON CARD
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            //navigate to patron registration
            print('Card tapped.');
          },
          child: SizedBox(
              width: 300,
              height: 100,
              child: Column(
                  children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Patron',
                        style: GoogleFonts.abhayaLibre(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25,
                        ))),
                  ]

                          // style: TextStyle(fontFamily: 'RototoMono')
                          )),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Find works by creators near you',
                        style: GoogleFonts.abhayaLibre(
                            textStyle: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            )))
                  )
                )
              ])),
        ),
      )
    ]);
  }
}



class _RegistrationPageState extends State<RegistrationPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
                  UserChoiceButtons()
                  // Text(
                  //   'You have clicked the button this many times:',
                  // ),
                  // Text(
                  //   '$_counter',
                  //   style: Theme.of(context).textTheme.headline4,
                  // ),
                ],
              ),
            )));
  }////
}
