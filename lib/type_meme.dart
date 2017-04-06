import 'package:flutter/material.dart';

class TypeMeme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TypeMemeState();
}

// Represents the states of typing text onto an image to make a meme.
class TypeMemeState extends State<TypeMeme> {
  TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Make yo meme')),
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
    ThemeData themeData = Theme.of(context);
    return new Row(children: <Widget>[
      new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
      ),
      new Flexible(
          child: new TextField(
              controller: _textController,
              onSubmitted: (String text) => _insertMemeIntoChat(),
              onChanged: _handleMessageChanged)),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(
            icon: new Icon(Icons.send),
            onPressed: _insertMemeIntoChat,
            color:
                _isComposing ? themeData.accentColor : themeData.disabledColor,
          ))
    ]);
  }

  void _handleMessageChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  void _insertMemeIntoChat() {
    Navigator.of(context).pop();
    // TODO(efortuna): Store your created meme (in widget form?)
    // (uploading images to Firebase will require testing).
  }
}
