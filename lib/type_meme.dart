// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'platform_adaptive.dart';

class TypeMeme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TypeMemeState();
}

// Represents the states of typing text onto an image to make a meme.
class TypeMemeState extends State<TypeMeme> {
  TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new PlatformAdaptiveAppBar(
          title: new Text("Make yo meme"),
          platform: Theme.of(context).platform,
        ),
        body: new Column(children: <Widget>[
          new Stack(children: [
            new Image.asset('assets/test_image.jpg'),
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
              onSubmitted: (String text) => _insertMemeIntoChat())),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new PlatformAdaptiveButton(
            icon: new Icon(Icons.send),
            onPressed: _insertMemeIntoChat,
            child: new Text("Send"),
          ))
    ]);
  }

  void _insertMemeIntoChat() {
    Navigator.of(context).pop();
    // TODO(efortuna): Store your created meme (in widget form?)
    // (uploading images to Firebase will require testing).
  }
}
