import 'package:flutter/cupertino.dart';

class NavItem {
  NavItem({required this.text, required this.icon, required this.page});
  final String text;
  final IconData icon;
  Route page;
}
