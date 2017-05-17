// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'platform_adaptive.dart';

class TypeMemeRoute extends MaterialPageRoute<String> {
  TypeMemeRoute(File imageFile)
      : super(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return new TypeMemeDialog(imageFile: imageFile);
            });
}

class TypeMemeDialog extends StatefulWidget {
  final File imageFile;

  TypeMemeDialog({this.imageFile});

  @override
  State<StatefulWidget> createState() => new TypeMemeDialogState();
}

// Represents the states of typing text onto an image to make a meme.
class TypeMemeDialogState extends State<TypeMemeDialog> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new PlatformAdaptiveAppBar(
        title: new Text("New meme"),
        platform: Theme.of(context).platform,
        actions: <Widget>[
          new FlatButton(
            child: new Text('SEND',
                style: new TextStyle(
                  color: defaultTargetPlatform == TargetPlatform.iOS
                      ? Colors.black
                      : Colors.white,
                )),
            onPressed: () => Navigator.pop(context, _text),
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new SingleChildScrollView(
              child: new Stack(
                children: [
                  new Image.file(widget.imageFile, width: 250.0),
                  new Positioned.fill(
                    child: new Container(
                        alignment: FractionalOffset.topCenter,
                        child: new Text(_text,
                            style: const TextStyle(
                                fontFamily: 'Anton',
                                fontSize: 37.5,
                                color: Colors.white),
                            softWrap: true,
                            textAlign: TextAlign.center)),
                  ),
                ],
                alignment: FractionalOffset.topCenter,
              ),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 16.0),
            child: new TextField(
              decoration: const InputDecoration(hintText: 'Meme text'),
              onChanged: (String text) {
                setState(() {
                  _text = text;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
