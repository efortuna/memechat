import 'package:flutter/material.dart';

class TypeMeme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TypeMemeState();
}

// Represents the states of typing text onto an image to make a meme.
class TypeMemeState extends State<TypeMeme> {
  InputValue _currentMessage = InputValue.empty;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Make yo meme')),
        body: new Column(children: <Widget>[
          new Stack(children: [
            new Image.asset('assets/test_image.jpg'),
            new Text(_currentMessage.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Impact'))
          ]),
          _buildTextComposer(),
        ]));
  }

  bool get _isComposing => _currentMessage.text.length > 0;

  Widget _buildTextComposer() {
    ThemeData themeData = Theme.of(context);
    return new Row(children: <Widget>[
      new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
      ),
      new Flexible(
          child: new Input(
              value: _currentMessage,
              onChanged: _handleMessageChanged,
              onSubmitted: (InputValue value) => _insertMemeIntoChat())),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(
            icon: new Icon(Icons.send),
            onPressed: _isComposing ? null : _insertMemeIntoChat,
            color:
                _isComposing ? themeData.accentColor : themeData.disabledColor,
          ))
    ]);
  }

  void _handleMessageChanged(InputValue value) {
    setState(() {
      _currentMessage = value;
    });
  }

  void _insertMemeIntoChat() {
    Navigator.of(context).pop();
    // TODO(efortuna): Store your created meme (in widget form?)
    // (uploading images to Firebase will require testing).
  }
}
