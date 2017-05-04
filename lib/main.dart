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
  Widget build(var context) {
    return new MaterialApp(
        title: "Memechat",
        home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State with TickerProviderStateMixin {
  var _messages = [];
  var _messagesReference = FirebaseDatabase.instance.reference();
  var _textController = new TextEditingController();
  var _isComposing = false;
  var _googleSignIn;

  @override
  void initState() {
    super.initState();
    GoogleSignIn.initialize(scopes: []);
    GoogleSignIn.instance.then((var instance) {
      setState(() {
        _googleSignIn = instance;
        _googleSignIn.signInSilently();
      });
    });
  }

  @override
  void dispose() {
    for (var message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  void _handleMessageChanged(var text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  void _handleSubmitted(var text) {

  }

  void _addMessage(
      {var name,
        var text,
        var imageUrl,
        var textOverlay,
        var senderImageUrl}) {
    var animationController;
    var sender = new ChatUser(name: name, imageUrl: senderImageUrl);
    var message = new ChatMessage(
        sender: sender,
        text: text,
        imageUrl: imageUrl,
        textOverlay: textOverlay,
        animationController: animationController);
    if (animationController != null) {
      animationController.forward();
    }
  }

  Future _handlePhotoButtonPressed() async {

  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new PlatformAdaptiveContainer(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: [
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
              ),
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

  Widget build(var context) {
    return new Scaffold(
        appBar: new PlatformAdaptiveAppBar(
            title: new Text("Memechat"),
            platform: Theme.of(context).platform,
        ),
        body: new Column(children: [
          new Flexible(
              child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, var index) =>
                  new ChatMessageListItem(_messages[index]),
                  itemCount: _messages.length,
              )),
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
  final name;
  final imageUrl;
}

class ChatMessage {
  ChatMessage(
      {this.sender,
        this.text,
        this.imageUrl,
        this.textOverlay,
        this.animationController});
  final sender;
  final text;
  final imageUrl;
  final textOverlay;
  final animationController;
}

class ChatMessageListItem extends StatelessWidget {
  ChatMessageListItem(this.message);

  final message;

  Widget build(var context) {
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: new CircleAvatar(),
              ),
              new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(message.sender.name,
                        style: Theme.of(context).textTheme.subhead),
                    new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new ChatMessageContent(message)),
                  ],
              ),
            ],
        ),
    );
  }
}

class ChatMessageContent extends StatelessWidget {
  ChatMessageContent(this.message);

  final message;

  Widget build(var context) {
    if (message.imageUrl != null) {
      var image = new Image.network(message.imageUrl, width: 200.0);
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
