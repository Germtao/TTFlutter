import 'package:flutter/material.dart';

/// 这个demo展示了如何使用一个简单的overlay
///
/// [overlay]组件能够让我们在当前页面上层覆盖一层新的组件
/// 通过 [Overlay.of(context)] 我们能够获得最近的root的OverlayState
/// 通过 [overlayState.insert(overlayEntry)]我们能够在当前页面上覆盖一层widget
/// 通过 [overlayEntry.remove()]能够移除掉覆盖层的[overlayEntry].
/// 当add多个overlayEntry的时候，先被add的会在下面，后被add的会在上面
class OverlayDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '在当前页面上覆盖新的组件overlay',
          style: TextStyle(fontSize: 36.0),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.fiber_smart_record),
            onPressed: () => showOverlay(context),
          );
        },
      ),
    );
  }

  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          color: Colors.pinkAccent,
        ),
      );
    });
    OverlayEntry overlayEntry2 = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
          width: 100.0,
          height: 50.0,
          color: Colors.tealAccent,
        ),
      );
    });

    overlayState.insert(overlayEntry);
    overlayState.insert(overlayEntry2);

    await Future.delayed(Duration(seconds: 2));

    overlayEntry.remove();
    overlayEntry2.remove();
  }
}
