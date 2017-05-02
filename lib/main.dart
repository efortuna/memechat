// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'type_meme.dart';
import 'platform_adaptive.dart';

const _name = "Emily";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Memechat",
        // TODO: Add platform adaptive theme
//      theme: defaultTargetPlatform == TargetPlatform.iOS
//          ? kIOSTheme
//          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<ChatMessage> _messages = <ChatMessage>[];
  DatabaseReference _messagesReference = FirebaseDatabase.instance.reference();
  TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    GoogleSignIn.initialize(scopes: <String>[]);
    GoogleSignIn.instance.then((GoogleSignIn instance) {
      setState(() {
        _googleSignIn = instance;
        _googleSignIn.signInSilently();
      });
    });
    // TODO: Add FirebaseAuth initialization
//    FirebaseAuth.instance.signInAnonymously().then((user) {
//      _messagesReference.onChildAdded.listen((Event event) {
//        var val = event.snapshot.val();
//        _addMessage(
//            name: val['sender']['name'],
//            senderImageUrl: val['sender']['imageUrl'],
//            text: val['text'],
//            imageUrl: val['imageUrl'],
//            textOverlay: val['textOverlay']);
//      });
//    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  void _handleMessageChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  void _handleSubmitted(String text) { // TODO: Fill out this function
//    _textController.clear();
//    PRE-PLUGINS
//    _addMessage(name: _name, text: text);
//    POST-PLUGINS
//    _googleSignIn.signIn().then((GoogleSignInAccount user) {
//      var message = {
//        'sender': {'name': user.displayName, 'imageUrl': user.photoUrl},
//        'text': text,
//      };
//      _messagesReference.push().set(message);
//    });
  }

  void _addMessage(
      {String name,
      String text,
      String imageUrl,
      String textOverlay,
      String senderImageUrl}) {
    AnimationController animationController;
    // TODO: initialize animationController
//    AnimationController animationController = new AnimationController(
//      duration: new Duration(milliseconds: 700),
//      vsync: this,
//    );
    ChatUser sender = new ChatUser(name: name, imageUrl: senderImageUrl);
    ChatMessage message = new ChatMessage(
        sender: sender,
        text: text,
        imageUrl: imageUrl,
        textOverlay: textOverlay,
        animationController: animationController);
    // TODO: Insert message
//    setState(() {
//      _messages.insert(0, message);
//    });
    animationController.forward();
  }

  Future<Null> _handlePhotoButtonPressed() async { // TODO: Fill out this function
//    GoogleSignInAccount account = await _googleSignIn.signIn();
//    File imageFile = await ImagePicker.pickImage();
//    int random = new Random().nextInt(10000);
//    StorageReference ref =
//        FirebaseStorage.instance.ref().child("image_$random.jpg");
//    StorageUploadTask uploadTask = ref.put(imageFile);
//    String overlay =
//        await Navigator.push(context, new TypeMemeRoute(imageFile));
//    if (overlay == null) return;
//    Uri downloadUrl = (await uploadTask.future).downloadUrl;
//    var message = {
//      'sender': {'name': account.displayName, 'imageUrl': account.photoUrl},
//      'imageUrl': downloadUrl.toString(),
//      'textOverlay': overlay,
//    };
//    _messagesReference.push().set(message);
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new PlatformAdaptiveContainer(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  // TODO: Add photo icon button
//                child: new IconButton(
//                  icon: new Icon(Icons.photo),
//                  onPressed: _handlePhotoButtonPressed,
//                ),
              ),
              // TODO: Add TextField
//              new Flexible(
//                child: new TextField(
//                  controller: _textController,
//                  onSubmitted: _handleSubmitted,
//                  onChanged: _handleMessageChanged,
//                  decoration:
//                      new InputDecoration.collapsed(hintText: "Send a message"),
//                ),
//              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new PlatformAdaptiveButton(
                    icon: new Icon(Icons.send),
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                    child: new Text("Send"),
                  )
              ),
            ])));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new PlatformAdaptiveAppBar(
          title: new Text("Memechat"),
          platform: Theme.of(context).platform,
        ),
        body: new Column(children: <Widget>[
          // TODO: Add message display
//          new Flexible(
//              child: new ListView.builder(
//            padding: new EdgeInsets.all(8.0),
//            reverse: true,
//            itemBuilder: (_, int index) =>
//                new ChatMessageListItem(_messages[index]),
//            itemCount: _messages.length,
//          )),
          new Divider(height: 1.0),
          new Container(
              decoration: new BoxDecoration(
                  backgroundColor: Theme.of(context).cardColor),
              child: _buildTextComposer()),
        ])
    );
  }
}

class ChatUser {
  ChatUser({this.name, this.imageUrl});
  final String name;
  final String imageUrl;
}

class ChatMessage {
  ChatMessage(
      {this.sender,
      this.text,
      this.imageUrl,
      this.textOverlay,
      this.animationController});
  final ChatUser sender;
  final String text;
  final String imageUrl;
  final String textOverlay;
  final AnimationController animationController;
}

class ChatMessageListItem extends StatelessWidget {
  ChatMessageListItem(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    return new Container( // TODO: Add SizeTransition
//    return new SizeTransition(
//        sizeFactor: new CurvedAnimation(
//            parent: message.animationController, curve: Curves.easeOut),
//        axisAlignment: 0.0,
//        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(), // TODO: Replace with GoogleUserCircleAvatar
//                child: new GoogleUserCircleAvatar(message.sender.imageUrl),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(message.sender.name,
                      style: Theme.of(context).textTheme.subhead),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new ChatMessageContent(message)),
                ],
              ),
            ],
          ),
//        )
    );
  }
}

class ChatMessageContent extends StatelessWidget {
  ChatMessageContent(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    if (message.imageUrl != null) {
      Image image = new Image.network(message.imageUrl, width: 200.0);
      if (message.textOverlay == null) {
        return image;
      } else {
        return new Stack(
          alignment: FractionalOffset.topCenter,
          children: [
            image,
            new Text(
              message.textOverlay,
              style: const TextStyle(fontFamily: 'Impact'),
            ),
          ],
        );
      }
    } else
      return new Text(message.text);
  }
}
