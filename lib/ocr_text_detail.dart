import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
class OcrTextDetail extends StatefulWidget {
  final OcrText ocrText;

  OcrTextDetail(this.ocrText);

  @override
  _OcrTextDetailState createState() => new _OcrTextDetailState();
}

class _OcrTextDetailState extends State<OcrTextDetail> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Text'),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text(widget.ocrText.value),
            subtitle: const Text('Value'),
          ),
        ],
      ),
    );
  }
}
