import 'package:flutter/material.dart';

//Navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const String SessionPath = 'assets/sessions.txt';

//Colors
const Color mainColor = Color.fromARGB(255, 23, 32, 58);
const Color secondColor = Color.fromRGBO(37, 132, 147, 186);
const Color dangerColor = Color(0xffEA5A5A);
const Color successColor = Color(0xff6cc070);
const Color backgroundColor = Color(0xfffafafa);
const Color textColor = Colors.black;
const Color textColorOnSecondColor = Color(0xFFf24300);
const Color textColorOnMainColor = Colors.white;
const Color shadowColor = Colors.blueGrey;
const Color mainButtonColor = mainColor;
//Input styles
const OutlineInputBorder inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: mainColor),
  borderRadius: BorderRadius.all(
    Radius.circular(borderRadius),
  ),
);

const UnderlineInputBorder inputUnderlineBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: mainColor),
);

const TextStyle labelTextStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor);
const Icon dropdownIcon = Icon(
  Icons.arrow_downward,
  size: 20,
);

const TextStyle inputTextStyle = TextStyle(fontSize: 15, color: textColor);
const double inputHeight = 13;
const InputDecoration inputFieldStyle = InputDecoration(
    suffixIconConstraints: BoxConstraints.tightForFinite(),
    prefixIconConstraints: BoxConstraints.tightForFinite(),
    hoverColor: backgroundColor,
    filled: true,
    fillColor: backgroundColor,
    isDense: true,
    contentPadding:
        EdgeInsets.only(top: inputHeight, bottom: inputHeight, right: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.red),
    ),
    errorStyle: TextStyle(color: dangerColor),
    prefixText: '   ');

final InputDecoration inputFieldStyleDropdown = inputFieldStyle.copyWith(
  contentPadding: const EdgeInsets.only(
      top: inputHeight - 2.75, bottom: inputHeight - 2.75, right: 10),
);

//error messages
String fieldNotfound = 'This field does not exist';
String? globToken;

//Screen sizes
const int mobileWidth = 600;
const int tabletWidth = 1000;

//Horizontal padding for screen sizes
const double mobilePadding = 15;
const double aboveMobilePadding = 40;

//Button spacing
const double horizontalButtonSpacing = 15;
const double verticalButtonSpacing = 10;

//Button height
const double buttonHeight = 35;
const double desktopButtonWidth = 300;

//Border Radius
const double borderRadius = 10;