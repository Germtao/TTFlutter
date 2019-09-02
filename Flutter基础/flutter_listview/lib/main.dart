import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List View Widget',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List View Widget'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('person'),
            ),
            ListTile(
              leading: Icon(Icons.perm_camera_mic),
              title: Text('perm_camera_mic'),
            ),
            ListTile(
              leading: Icon(Icons.access_alarm),
              title: Text('access_alarm'),
            ),
            Image.network('http://jspang.com/static/upload/20181030/cETrXVG2NPDHD_3T0GMzsnmc.png'),
            Image.network('http://blogimages.jspang.com/flutter_ad2.jpg')
          ],
        ),
      ),
    );
  }
}