import 'package:flutter/material.dart';

class NavItem {
  NavItem({required this.text, required this.icon, required this.page});
  final String text;
  final IconData icon;
  Widget Function(BuildContext context) page;
}
