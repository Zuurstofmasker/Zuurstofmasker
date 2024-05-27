import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class CameraStatus extends StatelessWidget {
  const CameraStatus({super.key, this.status = false});

  final bool status;

  @override
  Widget build(BuildContext context) {
      return Row(
        children: [
          if(status)
          const Icon(
            Icons.check,
            color: successColor,
          )
          else 
          const Icon(
            Icons.dangerous,
            color: dangerColor,
          ),
          const PaddingSpacing(
            multiplier: 0.5,
          ),
          Text(status ? "Camera beschikbaar" : "Geen cameras beschikbaar")
        ],
      );
  }
}
