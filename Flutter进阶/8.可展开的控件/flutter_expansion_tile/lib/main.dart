import 'package:flutter/material.dart';
import 'expansion_tile_widget.dart';
import 'expandsion_panel_list_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expansion Tile',
      theme: ThemeData.dark(),
      // home: ExpansionTileWidget(),
      home: ExpandsionPanelListWidget(),
    );
  }
}
