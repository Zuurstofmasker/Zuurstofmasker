import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/navItem.dart';
import 'package:zuurstofmasker/config.dart';

void popPage() {
  navigatorKey.currentState!.pop();

  // TODO: implement menu change when popping
}

void pushPage<T>(MaterialPageRoute<T>? page) {
  navigatorKey.currentState!.pushAndRemoveUntil(page!, (r) => false);

  int count = 0;
  for (NavItem element in Nav(
    child: const Text(""),
  ).menuItems) {
    count++;
    if (page.builder.toString() == element.page.builder.toString()) {
      MenuIndex.index = count - 1;
    }
  }
}
