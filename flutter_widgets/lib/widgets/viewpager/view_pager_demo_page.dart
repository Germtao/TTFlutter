import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/viewpager/view_pager_transformer.dart';
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
                transformer: ViewPagerTransformer(TransformerType.Accordion),
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        'Accordion: $index',
                        style: TextStyle(fontSize: 50, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TransformerPageView(
                loop: true,
                transformer: ViewPagerTransformer(TransformerType.ThreeD),
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        'ThreeD: $index',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TransformerPageView(
                loop: true,
                transformer: ViewPagerTransformer(TransformerType.ZoomIn),
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        'ZoomIn: $index',
                        style: TextStyle(fontSize: 50, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TransformerPageView(
                loop: true,
                transformer: ViewPagerTransformer(TransformerType.ZoomOut),
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        'ZoomOut: $index',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TransformerPageView(
                loop: true,
                transformer: ViewPagerTransformer(TransformerType.Deepth),
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        'Deepth: $index',
                        style: TextStyle(fontSize: 50, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TransformerPageView(
                loop: true,
                transformer: ViewPagerTransformer(TransformerType.ScaleAndFade),
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length],
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        'ScaleAndFade: $index',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
