import 'package:flutter/material.dart';
import 'dynamic_view.dart';

class BottomAppBarWidget extends StatefulWidget {
  @override
  _BottomAppBarWidgetState createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {

  List<Widget> _viewList;
  int _currentIndex = 0;

  // 初始化
  @override
  void initState() {
    super.initState();

    _viewList = List();
    _viewList
      ..add(DynamicView('Home'))
      ..add(DynamicView('AirPlay'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _viewList[_currentIndex],
      floatingActionButton: FloatingActionButton(
        tooltip: '添加',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: (){
//          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
//            return DynamicView('New Page');
//          }));

          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return DynamicView('New Page');
          }));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: (){
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.airplay),
              color: Colors.white,
              onPressed: (){
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
