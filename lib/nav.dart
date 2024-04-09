import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Dashborad/main.dart';
import 'package:zuurstofmasker/TestPage.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:zuurstofmasker/main.dart';

import 'navItem.dart' as navItem;

class MenuIndex {
  static int? index = 0;
}

class Nav extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final double appBarHeight;
  final bool centerTitle;

  //fil the list of custom InputField classes
  final List<navItem.NavItem> menuItems = [
    navItem.NavItem(
        text: 'Dashborad',
        icon: Icons.home,
        page: MaterialPageRoute(builder: (context) => const Dashborad())),
    navItem.NavItem(
        text: 'HomePage',
        icon: Icons.add_chart,
        page: MaterialPageRoute(
            builder: (context) => MyHomePage(title: "test title"))),
    navItem.NavItem(
        text: 'testPAge',
        icon: Icons.photo,
        page: MaterialPageRoute(builder: (context) => const TestPage())),
  ];

  Nav({
    required this.child,
    this.title,
    this.actions,
    this.appBarHeight = kToolbarHeight,
    this.centerTitle = true,
  });

  //get and put the menu items from the list to the widgets for non mobile
  List<Widget> getMenuItems(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<Widget> items = [];
    int i = 0;

    items.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Image.asset(
          "assets/logo.jpg",
          height: 30,
          width: 30,
        ),
      ),
    );
    for (navItem.NavItem menuitem in menuItems) {
      items.add(
        MenuItemBase(
          page: menuitem.page,
          index: i,
          child: MenuItemDesktop(
            text: menuitem.text,
            icon: menuitem.icon,
            selected: (i == MenuIndex.index),
          ),
        ),
      );
      i++;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (title != null
          ? AppBar(
              centerTitle: centerTitle,
              shadowColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10 * 2),
                ),
              ),
              backgroundColor: Colors.white,
              title: title,
              elevation: 2,
              actions: actions,
              toolbarHeight: appBarHeight,
            )
          : null),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 250,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: getMenuItems(context),
              ),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class MenuItemDesktop extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool? selected;

  const MenuItemDesktop({this.text, this.icon, this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: selected! ? Colors.white : Colors.white,
          ),
          const SizedBox(width: 20),
          Text(
            text!,
            style: TextStyle(
                color: selected! ? Colors.white : Colors.white,
                fontSize: 12,
                height: 1.5),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class MenuItemBase extends StatelessWidget {
  final int? index;
  final Widget? child;
  final Route? page;

  MenuItemBase({required this.index, required this.child, required this.page});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        alignment: Alignment.center,
        backgroundColor:
            index == MenuIndex.index ? Colors.lightBlue : Colors.blue,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      onPressed: () {
        MenuIndex.index = index;
        navigatorKey.currentState?.pushAndRemoveUntil(page!, (r) => false);
      },
      child: child,
    );
  }
}
