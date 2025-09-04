import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onButtonTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onButtonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Image.asset('assets/live_icon.png', scale: 8),
            iconSize: 3,
            onPressed: () => onButtonTapped(0),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: Image.asset('assets/summary_icon.png', scale: 8),
            iconSize: 3,
            onPressed: () => onButtonTapped(1),
          ),
        ],
      ),
    );
  }
}