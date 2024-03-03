import 'package:flutter/material.dart';

class UserActionItem extends StatelessWidget {
  final bool isIconActive;
  final IconData? activeIcon;
  final IconData? inActiveIcon;
  final String text;
  final Function() onTap;
  const UserActionItem({super.key, this.isIconActive = false, this.activeIcon, this.inActiveIcon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: isIconActive
              ? Icon(activeIcon,
              color: Colors.white, size: 30)
              : Icon(inActiveIcon,
              color: Colors.white, size: 30),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
              fontSize: 12, color: Colors.white),
        )
      ],
    );
  }
}
