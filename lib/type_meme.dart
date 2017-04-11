// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'platform_adaptive.dart';

class TypeMeme extends StatefulWidget {
  final GoogleSignIn _googleSignIn;
  final DatabaseReference _messagesReference;
  Uri downloadUrl;

  TypeMeme(this._googleSignIn, this._messagesReference, this.downloadUrl);

  @override
  State<StatefulWidget> createState() => new TypeMemeState(downloadUrl);
}

// Represents the states of typing text onto an image to make a meme.
class TypeMemeState extends State<TypeMeme> {
  TextEditingController _textController = new TextEditingController();
  Uri downloadUrl;
  Image image;

  TypeMemeState(this.downloadUrl) {
    _setImage();
  }

  void _setImage() {
    image = new Image.network(downloadUrl.toString(), width: 250.0);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new Scaffold(
        appBar: new PlatformAdaptiveAppBar(
          title: new Text("Make yo meme"),
          platform: Theme.of(context).platform,
        ),
        body: new Column(children: <Widget>[
          new IconButton(
              icon: new Icon(Icons.camera_alt),
              color: themeData.accentColor,
              onPressed: () async {
                downloadUrl = await pickAndUploadImage();
                setState(() {
                  _setImage();
                });
              }),
          new Stack(children: [
            image,
            new Text(_textController.text,
                style: const TextStyle(fontFamily: 'Impact'))
          ], alignment: FractionalOffset.topCenter),
          _buildTextComposer(),
        ]));
  }

  Widget _buildTextComposer() {
    return new Row(children: <Widget>[
      new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
      ),
      new Flexible(
          child: new TextField(
              controller: _textController,
              onChanged: (String text) =>
                  setState(() {}), // rebuild ui to show meme text
              onSubmitted: (String text) =>
                  downloadUrl != null ? _insertMemeIntoChat() : null)),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new PlatformAdaptiveButton(
            icon: new Icon(Icons.send),
            onPressed: _insertMemeIntoChat,
            child: new Text("Send"),
          ))
    ]);
  }

  Future<Null> _insertMemeIntoChat() async {
    GoogleSignInAccount account = await config._googleSignIn.signIn();
    var message = {
      'sender': {'name': account.displayName, 'imageUrl': account.photoUrl},
      'imageUrl': downloadUrl.toString(),
      'textOverlay': _textController.text
    };
    config._messagesReference.push().set(message);
    Navigator.of(context).pop();
  }
}

Future<Uri> pickAndUploadImage() async {
  File imageFile = await ImagePicker.pickImage();
  int random = new Random().nextInt(10000);
  StorageReference ref =
      FirebaseStorage.instance.ref().child("image_$random.jpg");
  StorageUploadTask uploadTask = ref.put(imageFile);
  return (await uploadTask.future).downloadUrl;
}
