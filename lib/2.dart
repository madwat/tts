import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:translator/translator.dart';
class MyREC extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

enum TtsState { playing, stopped }

class _MyAppState extends State<MyREC> {
  SpeechRecognition _speech;
FlutterTts flutterTts;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
 TtsState ttsState = TtsState.stopped;
  dynamic languages1;
  dynamic voices;
  String language = 'en_US';
  String voice;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  String transcription = '';

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    initTts();
     start();
    _speak();
  }
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

 void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res))
              .then((res)  => _speak());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Перевод речи'),
        ),
        body: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Center(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new Expanded(
                      child: new Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: Text(transcription)
                          )),
                ],
              ),
            )),
      ),
    );
  }

  void start() => _speech
      .listen(locale: 'ru_RU')
      .then((result) => print('_MyAppState.start => result 0'));
  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));
  void stop() =>
      _speech.stop().then((result) => setState(() => _isListening = result));
  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);
  void onRecognitionStarted() => setState(() => _isListening = true);
  void onRecognitionResult(String text) => setState(() => transcription = text);
  void onRecognitionComplete() => setState(() => _isListening = false);

 Future _speak() async {
   await Future.delayed(new Duration(seconds: 5));
   GoogleTranslator translator = GoogleTranslator();
    var translation = await translator.translate(transcription, from: 'ru', to: 'en');
    await flutterTts.setLanguage("en-US");
    await flutterTts.isLanguageAvailable("en-US");
     if (translation != null) {
      if (translation.isNotEmpty) {
        var result1 = await flutterTts.speak(translation);
        if (result1 == 1) setState(() => ttsState = TtsState.playing);
      }
    }   
  }
}