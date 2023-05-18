import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_office/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore =
      FirebaseFirestore.instance; // Firestore.instance doesn't work
  /// in trouble
  late User loggedInUser;
  String messageText = '';
  Stream collectionStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  Stream documentStream =
      FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    /// This line is from Angela Yu course,
    /// but this line doesn't work
    //final user = await _auth.currentUser();
    /// the following line is from
    /// https://firebase.flutter.dev/docs/auth/manage-users
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /// 1 May 2023
  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       var messageData = message.data();
  //       var messageSender = messageData['sender'];
  //       var messageText = messageData['text'];
  //       //print(messageData);
  //       print("$messageSender | ======> $messageText");
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
                //messagesStream();
              }),
        ],
        title: Text(
          '⚡️Chat',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, parcel) {
                if (parcel.hasData) {
                  final messages = parcel.data;
                  List<Text> messageWidgets = [];
                  return Column(
                   children: [
                      Text("Here"),
                   ],
                  );
                } else if (parcel.hasError) {
                  return Text('Error: ${parcel.error}');
                } else {
                  return Text("Waiting For Data");
                }
              },
            ),

            // StreamBuilder(stream: _firestore.collection('messages').snapshots(), builder: (context,snapshot) {
            //   if (snapshot.hasData){
            //     final messages = snapshot.docs;
            //     List<Text> messageWidgets = [];
            //     for (var message in messages){
            //
            //     }
            //
            //   }
            // })
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value; //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //we have messageText + loggedInUser.email

                      print('Send button pressed');
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                      print('${loggedInUser.email} is logged in');
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
