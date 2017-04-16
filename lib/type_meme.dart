// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';

import 'platform_adaptive.dart';

class TypeMemeRoute extends MaterialPageRoute<String> {
  TypeMemeRoute(File imageFile) : super(
    builder: (BuildContext context) {
      return new TypeMeme(imageFile);
    }
  );
}

class TypeMeme extends StatefulWidget {
  final File imageFile;

  TypeMeme(this.imageFile);

  @override
  State<StatefulWidget> createState() => new TypeMemeState();
}

// Represents the states of typing text onto an image to make a meme.
class TypeMemeState extends State<TypeMeme> {
  String _text = '';

  void _handleTextChanged(String text) {
    setState(() {
      _text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new Scaffold(
      appBar: new PlatformAdaptiveAppBar(
        title: new Text("Make yo meme"),
        platform: Theme.of(context).platform,
      ),
      body: new Column(
        children: <Widget>[
          new Stack(
            children: [
              new Image.file(widget.imageFile, width: 250.0),
              new Text(_text, style: const TextStyle(fontFamily: 'Impact')),
            ],
            alignment: FractionalOffset.topCenter,
          ),
          new Container(
            margin: new EdgeInsets.only(left: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    onChanged: _handleTextChanged,
                    onSubmitted: (_) => _finish(),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new PlatformAdaptiveButton(
                    icon: new Icon(Icons.send),
                    onPressed: _finish,
                    child: new Text("Send"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _finish() {
    Navigator.pop(context, _text);
  }
}
