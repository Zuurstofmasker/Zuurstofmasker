import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/config.dart';

class StatusIndictor extends StatelessWidget {
  const StatusIndictor({
    super.key,
    this.status = false,
    required this.statusStream,
    required this.name,
  });

  final Stream<List<bool>> statusStream;
  final String name;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<bool>>(
        stream: statusStream,
        builder: (context, snapshot) {
          final bool finalStatus = snapshot.data?.every((e) => e) ?? status;
          return Row(
            children: [
              if (finalStatus)
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
              Text(
                finalStatus ? "$name beschikbaar" : "$name niet beschikbaar",
              )
            ],
          );
        });
  }
}
