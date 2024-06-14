import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';

class Button extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Function() onTap;
  final Color color;
  final EdgeInsets padding;
  final bool isFullWidth;
  const Button({
    super.key,
    this.icon,
    this.text,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.color = secondaryColor,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
          minimumSize: const Size(10, 48),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
              ),
            if (text != null && icon != null)
              const SizedBox(
                width: 5,
              ),
            if (text != null)
              Text(
                text!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              )
          ],
        ),
      ),
    );
  }
}
