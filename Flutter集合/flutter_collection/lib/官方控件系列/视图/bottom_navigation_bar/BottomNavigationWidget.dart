import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/airplay_screen.dart';
import 'pages/email_screen.dart';
import 'pages/profile_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {

  final _bottomNavigationBarItemColor = Colors.blue;

  int _currentIndex = 0; // 当前页
  var pagesList = List<Widget>();

  @override
  void initState() {

    pagesList
      ..add(HomeScreen())
      ..add(AirPlayScreen())
      ..add(EmailScreen())
      ..add(ProfileScreen());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagesList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _bottomNavigationBarItemColor),
              title: Text('Home', style: TextStyle(color: _bottomNavigationBarItemColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplay, color: _bottomNavigationBarItemColor),
              title: Text('Airplay', style: TextStyle(color: _bottomNavigationBarItemColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.email, color: _bottomNavigationBarItemColor),
              title: Text('Email', style: TextStyle(color: _bottomNavigationBarItemColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: _bottomNavigationBarItemColor),
              title: Text('Profile', style: TextStyle(color: _bottomNavigationBarItemColor),)
          )
        ],
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(opacity: 1.0),
        unselectedIconTheme: IconThemeData(opacity: 0.5),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
