import 'package:flutter/material.dart';

class NavItem {
  NavItem({required this.text, required this.icon, required this.page});
  final String text;
  final IconData icon;
  MaterialPageRoute page;
}
