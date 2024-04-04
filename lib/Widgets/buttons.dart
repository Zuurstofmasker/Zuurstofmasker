import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  const Button({
    super.key,
    required this.icon,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        iconColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
        )),
        backgroundColor: MaterialStateProperty.all(
          selected ? Colors.white.withAlpha(50) : Colors.blue,
        ),
      ),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 15,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
