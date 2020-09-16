import 'package:flutter/material.dart';

/// 通过[renderobject]获取控件中心位置
class OverlayDemo3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Render Demo'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: OverlayContainer(),
          );
        },
      ),
    );
  }
}

class OverlayContainer extends StatefulWidget {
  @override
  _OverlayContainerState createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openOverlay,
      child: Container(
        alignment: Alignment.center,
        height: 200,
        color: Colors.black.withOpacity(0.2),
      ),
    );
  }

  void openOverlay() {
    OverlayState overlayState = Overlay.of(context);

    final RenderBox renderBox = context.findRenderObject();
    final Offset offset = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    final width = 100.0;
    final height = 100.0;

    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: offset.dy - height / 2,
        left: offset.dx - width / 2,
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          child: Material(
            child: Text('${offset.toString()}'),
          ),
        ),
      );
    });

    overlayState.insert(overlayEntry);
    Future.delayed(Duration(seconds: 1)).then((_) => overlayEntry.remove());
  }
}
