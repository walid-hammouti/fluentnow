import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/presentation/screens/homescreen.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/presentation/screens/courseslist.dart';
import 'package:fluentnow/naviagtion_home/News/presentation/screens/newsevents.dart';
import 'package:fluentnow/naviagtion_home/Likes/presentation/screens/likedcourses.dart';
import 'package:fluentnow/naviagtion_home/Subscription/presentation/screens/SubscriptionScreen.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndexTab = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CoursesListScreen(),
    NewsScreen(),
    LikedcoursesScreen(),
    SubscriptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(index: currentIndexTab, children: _pages),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.white,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Mycolors.primary,
          items: const [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.list_alt),
              label: 'Courses',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.newspaper_outlined),
              label: 'News',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.favorite_border),
              label: 'Liked',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.payment),
              label: 'Subscription',
            ),
          ],
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              currentIndexTab = index;
            });
          },
        ),
      ),
    );
  }
}
