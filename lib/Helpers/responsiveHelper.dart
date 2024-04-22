import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Config.dart';


bool isMobile(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth <= mobileWidth;
}

double getResponsiveWidth(BuildContext context,
    {bool isFullWidth = false, double width = desktopButtonWidth}) {
  if (isFullWidth) return double.infinity;

  return isMobile(context) ? double.infinity : width;
}

T responsifeCondition<T>(BuildContext context, T mobileValue, T desktopValue) {
  if (isMobile(context)) return mobileValue;
  return desktopValue;
}
