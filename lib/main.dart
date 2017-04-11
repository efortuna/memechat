// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'firebase_stubs.dart';
import 'type_meme.dart';
import 'platform_adaptive.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Friendlychat",
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new ChatScreen());
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
    FirebaseAuth.instance.signInAnonymously().then((user) {
      _messagesReference.onChildAdded.listen((Event event) {
        var val = event.snapshot.val();
        _addMessage(
            name: val['sender']['name'],
            senderImageUrl: val['sender']['imageUrl'],
            text: val['text'],
            imageUrl: val['imageUrl']);
      });
    });
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

  void _handleMessageAdded(String text) {
    _textController.clear();
    _googleSignIn.signIn().then((GoogleSignInAccount user) {
      var message = {
        'sender': {'name': user.displayName, 'imageUrl': user.photoUrl},
        'text': text,
      };
      _messagesReference.push().set(message);
    });
  }

  void _addMessage(
      {String name, String text, String imageUrl, String senderImageUrl}) {
    AnimationController animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );
    ChatUser sender = new ChatUser(name: name, imageUrl: senderImageUrl);
    ChatMessage message = new ChatMessage(
        sender: sender,
        text: text,
        imageUrl: imageUrl,
        animationController: animationController);
    setState(() {
      _messages.insert(0, message);
    });
    animationController.forward();
  }

  Widget _buildTextComposer() {
    ThemeData themeData = Theme.of(context);
    return new Row(children: <Widget>[
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(
              icon: new Icon(Icons.photo),
              color: themeData.accentColor,
              onPressed: () async {
                Uri downloadUrl = await pickAndUploadImage();
                Navigator.of(context).push(new MaterialPageRoute<bool>(
                    builder: (BuildContext context) {
                  return new TypeMeme(_googleSignIn, downloadUrl);
                }));
              })),
      new Flexible(
          child: new TextField(
              controller: _textController,
              onSubmitted: _handleMessageAdded,
              onChanged: _handleMessageChanged,
              decoration:
                  new InputDecoration.collapsed(hintText: "Enter message"))),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new PlatformAdaptiveButton(
            icon: new Icon(Icons.send),
            onPressed: _isComposing
                ? () => _handleMessageAdded(_textController.text)
                : null,
            child: new Text("Send"),
          ))
    ]);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new PlatformAdaptiveAppBar(
          title: new Text("Memechat"),
          platform: Theme.of(context).platform,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
              child: new ListView(
                  padding: new EdgeInsets.symmetric(horizontal: 8.0),
                  reverse: true,
                  children: _messages
                      .map((m) => new ChatMessageListItem(m))
                      .toList())),
          _buildTextComposer(),
        ]));
  }
}

class ChatUser {
  ChatUser({this.name, this.imageUrl});
  final String name;
  final String imageUrl;
}

class ChatMessage {
  ChatMessage(
      {this.sender, this.text, this.imageUrl, this.animationController});
  final ChatUser sender;
  final String text;
  final String imageUrl;
  final AnimationController animationController;
}

class ChatMessageListItem extends StatelessWidget {
  ChatMessageListItem(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: message.animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new GoogleUserCircleAvatar(message.sender.imageUrl),
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
        ));
  }
}

class ChatMessageContent extends StatelessWidget {
  ChatMessageContent(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    if (message.imageUrl != null)
      return new Image.network(message.imageUrl, width: 200.0);
    else
      return new Text(message.text);
  }
}
