import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class CameraStatus extends StatelessWidget {
  const CameraStatus({super.key, this.status = false});

  final bool status;

  @override
  Widget build(BuildContext context) {
    if (status) {
      return const Row(
        children: [
          Icon(
            Icons.check,
            color: successColor,
          ),
          PaddingSpacing(
            multiplier: 0.5,
          ),
          Text("Camera beschikbaar")
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(
            Icons.dangerous,
            color: dangerColor,
          ),
          PaddingSpacing(
            multiplier: 0.5,
          ),
          Text("Geen cameras beschikbaar")
        ],
      );
    }
  }
}
