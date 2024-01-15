import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_build/constants.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: elementColor,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          _goToBranch(selectedIndex);
        },
        iconSize: 35,
        activeColor: Color(0xFAFAFAFF),
        inactiveColor: Color(0xFAFAFAFF),
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(icon: Icons.home, title: 'Главная'),
          BarItem(icon: Icons.manage_search, title: 'Поиск'),
          BarItem(icon: Icons.shopping_cart, title: 'Корзина'),
          BarItem(icon: Icons.account_circle, title: 'Профиль'),
        ],
      ),
    );
  }
}
