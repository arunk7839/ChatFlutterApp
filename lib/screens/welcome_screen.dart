import 'package:chat_flutter_app/screens/login_screen.dart';
import 'package:chat_flutter_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/RoundTextField.dart';

class WelcomeScreen extends StatefulWidget {

  static const id = "welcome_screen";


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync:this ,duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    controller.addListener((){
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value*100,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundTextField(color: Colors.lightBlueAccent,buttonText:"Log In",onPressed: () {
              //Go to login screen.
              Navigator.pushNamed(context,LoginScreen.id );
            },),
            RoundTextField(color: Colors.blueAccent,buttonText:"Register",onPressed: () {
              //Go to login screen.
              Navigator.pushNamed(context,RegistrationScreen.id );
            },)
          ],
        ),
      ),
    );
  }
}


