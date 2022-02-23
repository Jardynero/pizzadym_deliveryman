import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final List<List> pagesItem;
  final Function(int) onTap;
  final int currentIndex;

  const BottomNavBar({
    required this.pagesItem,
    required this.onTap,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: widget.pagesItem
          .map(
            (item) => BottomNavigationBarItem(
              icon: item[0],
              label: item[1],
            ),
          )
          .toList(),
      onTap: widget.onTap,
      currentIndex: widget.currentIndex,
    );
  }
}
