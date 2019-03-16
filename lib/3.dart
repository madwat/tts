import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'ocr_text_detail.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class MyOCR extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
enum TtsState { playing, stopped }
class _MyAppState extends State<MyOCR> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
      _previewOcr = previewSizes[_cameraOcr].first;
    }));
   _read();
  }

  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Перевод'),
            ),
            body:  _getOcrScreen(context),
                ));
  }
  Widget _getOcrScreen(BuildContext context) {
    List<Widget> items = [];
    items.addAll(
      ListTile.divideTiles(
        context: context,
        tiles: _textsOcr
            .map(
              (ocrText) => new OcrTextWidget(ocrText),
            )
            .toList(),
      ),
    );
    return new ListView(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      children: items,
    );
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: false,
        autoFocus: true,
        multiple: false,
        waitTap: true,
        showText: true,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 1.0,
      );
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }
    if (!mounted) return;
    setState(() => _textsOcr = texts);
  }
}

class OcrTextWidget extends StatefulWidget {
  final OcrText ocrText;
  OcrTextWidget(this.ocrText);
  @override
  OcrTextWidgetState createState() => OcrTextWidgetState();
}

class OcrTextWidgetState extends State<OcrTextWidget> {
    @override
    void initState () {
      super.initState();
      initTts();
     _speak();
    }
FlutterTts flutterTts;
  String transcription = '';
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
initTts() {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new OcrTextDetail(widget.ocrText),
    );
  }

  Future _speak() async {
    GoogleTranslator translator = GoogleTranslator();
    String translation = await translator.translate(widget.ocrText.value, from: 'en', to: 'ru');
      if (translation != null) {
      if (translation.isNotEmpty) {
        try {
        var result1 = await flutterTts.speak(translation);
        if (result1 == 1) setState(() => ttsState = TtsState.playing);
        } catch (e) {print('error');}
      }
    }
  }
}
