import 'package:flutter/material.dart';

class TagDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TagDemoPage'),
        ),
        body: Container(
          child: Wrap(
            children: [
              TagItem('Start'),
              for (var item in tags) TagItem(item),
              TagItem('End'),
            ],
          ),
        ));
  }
}

class TagItem extends StatelessWidget {
  final String text;

  TagItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(60),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(text),
    );
  }
}

const List<String> tags = [
  "FFFFFFF",
  "TTTTTT",
  "LL",
  "JJJJJJJJ",
  "PPPPP",
  "OOOOOOOOOOOO",
  "9999999",
  "*&",
  "5%%%%%",
  "¥¥¥¥¥¥",
  "UUUUUUUUUU",
  "))@@@@@@"
];
