import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pax/screens/home.dart';
import 'package:pax/screens/posts/posts.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

final List<Widget> _pages = [
  const HomeScreen(),
  const PostsPage(),
];

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 450),
              curve: Curves.linear);
          setState(() {
            _selectedIndex = index;
          });
        },
        iconSize: 27.0,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF585C),
        unselectedItemColor: const Color(0xFFBAC4D1),
        elevation: 10.0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded), label: "Comminity")
        ],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    ));
  }
}
