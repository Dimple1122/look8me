import 'package:flutter/cupertino.dart';

class BottomSheetModalItem {
  IconData icon;
  String itemName;
  Function() onTap;
  BottomSheetModalItem({required this.icon, required this.itemName, required this.onTap});
}