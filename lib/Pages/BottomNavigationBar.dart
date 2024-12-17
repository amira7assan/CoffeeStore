import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/Pages/AdminHomePage.dart';
import 'package:ecommerce/Pages/Homepage.dart';
import 'package:ecommerce/Pages/Cart.dart';
import 'package:ecommerce/Pages/Favorites.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screen = [
    const HomePage(),
    const Favorites(),
    const Cart(),
  ];
  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screen,
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Colors.black.withOpacity(0.92),
          currentIndex: _currentIndex,
          onTap: _onTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.disabledCategoryColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  size: 30,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
                label: ""),
          ]),
    );
  }
}
