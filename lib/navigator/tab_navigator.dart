import 'package:first_app/pages/home_page.dart';
import 'package:first_app/pages/my_page.dart';
import 'package:first_app/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/pages/map_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Color(0xff03DAC5);
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          MapPage(),
          HomePage(),
          SearchPage(
            hideLeft: true,
          ),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.home, color: _defaultColor),
              activeIcon: Icon(Icons.home, color: _activeColor),
              title: Text('',
                  style: TextStyle(
                      color:
                          _currentIndex != 0 ? _defaultColor : _activeColor))),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _defaultColor),
              activeIcon: Icon(Icons.search, color: _activeColor),
              title: Text('',
                  style: TextStyle(
                      color:
                          _currentIndex != 1 ? _defaultColor : _activeColor))),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt, color: _defaultColor),
              activeIcon: Icon(Icons.camera_alt, color: _activeColor),
              title: Text('',
                  style: TextStyle(
                      color:
                          _currentIndex != 2 ? _defaultColor : _activeColor))),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: _defaultColor),
              activeIcon: Icon(Icons.account_circle, color: _activeColor),
              title: Text('my',
                  style: TextStyle(
                      color:
                          _currentIndex != 3 ? _defaultColor : _activeColor))),
        ],
      ),
    );
  }
}
