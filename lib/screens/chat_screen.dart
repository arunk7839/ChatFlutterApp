import 'package:flutter/material.dart';
import 'package:chat_flutter_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User logginUser;

class ChatScreen extends StatefulWidget {
  static const id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText="";
  final messageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    User? user = _auth.currentUser;
    if (user != null) {
      logginUser = user;
      print(logginUser.email);
    }
  }

  // Future<void> getMessages()  async {
  //    await for (var snapshot in _firestore.collection("messages").snapshots()) {
  //     for (var doc in snapshot.docs) {
  //       print(doc.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;

                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageController.clear();

                      //Implement send functionality.
                      _firestore.collection("messages").add(
                        {
                          "text":messageText,
                          "sender":logginUser.email,
                          "createdAt": FieldValue.serverTimestamp(),
                        }
                      );

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _firestore.collection("messages").orderBy("createdAt", descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,),
            );
          }
          List<MessageBubble> messageBubbles = [];
          final messages = snapshot.data?.docs.reversed;
          for (var message in messages!) {
            var messageText = message.data()['text'];
            var senderText = message.data()['sender'];
            var currentUser = logginUser.email;

            messageBubbles.add(
                MessageBubble(text: messageText, sender: senderText,itsMe: currentUser == senderText,));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10.0),
              children: messageBubbles,
            ),
          );
        });
  }
}


class MessageBubble extends StatelessWidget {

  String text;
  String sender;
  bool itsMe;
   MessageBubble({required this.sender,required this.text, required this.itsMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: itsMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black54
            ),
          ),
          Material(
              elevation: 5.0,
              borderRadius: itsMe?BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ):BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: itsMe?Colors.lightBlueAccent:Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('$text',
                  style: TextStyle(fontSize: 15.0, color: itsMe?Colors.white:Colors.black),),
              )),
        ],
      )

    );
  }
}

