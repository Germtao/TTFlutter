import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class ViewPagerDemoPage extends StatelessWidget {
  final List<Color> colorList = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text('ViewPagerDemoPage'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TransformerPageView(
                loop: false,
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(fontSize: 80, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TransformerPageView(
                loop: true,
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(fontSize: 80, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
