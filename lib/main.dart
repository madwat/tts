import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '1.dart';
import '2.dart';
import '3.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter тест',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
  
}
class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int i = 0;
  var pages = [
    new MyTTS(),
    new MyREC(),
    new MyOCR()
  ];
 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: pages[i],
      bottomNavigationBar: new BottomNavigationBar(
        items: [
            new BottomNavigationBarItem(
            icon: new Icon(Icons.record_voice_over),
            title: new Text('TTS'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.surround_sound),
            title: new Text('REC'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.remove_red_eye),
            title: new Text('OCR'),
          ),
        ],
        currentIndex: i,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            i = index;
          });
        },
      ),
    );
  }
}
