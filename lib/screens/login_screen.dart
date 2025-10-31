import 'package:chat_flutter_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/RoundTextField.dart';
import '../constants.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class LoginScreen extends StatefulWidget {

  static const id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showProgress=false;

  final _auth = FirebaseAuth.instance;
  String email="";
  String password="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 600.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                decoration: kTextFieldInputDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  password = value;

                },
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: kTextFieldInputDecoration.copyWith(hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundTextField(color: Colors.lightBlueAccent,buttonText:"Log In",
                onPressed: () async{
                setState(() {
                  showProgress = true;
                });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    showProgress = false;
                  });
                }
                catch(e){
                  print(e);
                }
              },)

            ],
          ),
        ),
      ),
    );
  }
}
