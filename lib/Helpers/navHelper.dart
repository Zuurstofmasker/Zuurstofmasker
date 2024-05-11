import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/config.dart';

void popPage({BuildContext? context}) {
  if (context != null) {
    Navigator.of(context).pop();
  } else {
    navigatorKey.currentState!.pop();
  }
  routesStack.removeLast();
  determineMenuIndex();
}

void pushAndReplacePage<T>(MaterialPageRoute<T> page, {BuildContext? context}) {
  if (context != null) {
    Navigator.of(context).pushReplacement(page);
  } else {
    navigatorKey.currentState!.pushReplacement(page);
  }
  routesStack.removeLast();
  routesStack.add(page);
  determineMenuIndex();
}

void replaceAllPages<T>(MaterialPageRoute<T> page, {BuildContext? context}) {
  if (context != null) {
    Navigator.of(context).pushAndRemoveUntil(page, (r) => false);
  } else {
    navigatorKey.currentState!.pushAndRemoveUntil(page, (r) => false);
  }
  routesStack.clear(); // Clear the stack since it's being replaced
  routesStack.add(page);
  determineMenuIndex();
}

void pushPage<T>(MaterialPageRoute<T> page, {BuildContext? context}) {
  if (context != null) {
    Navigator.of(context).push(page);
  } else {
    navigatorKey.currentState!.push(page);
  }
  routesStack.add(page);
  determineMenuIndex();
}

void determineMenuIndex() {
  MenuIndex.index = -1;

  // Iterate through the stack in reverse order
  for (int i = routesStack.length - 1; i >= 0; i--) {
    MaterialPageRoute element = routesStack.elementAt(i);

    // Iterate through the menu items to find a match
    for (int j = 0; j < Nav.menuItems.length; j++) {
      if (Nav.menuItems[j].page.runtimeType == element.builder.runtimeType) {
        // Set the index and exit the loop once a match is found
        MenuIndex.index = j;
        return;
      }
    }
  }
}
