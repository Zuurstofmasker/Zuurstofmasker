import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';
import 'package:zuurstofmasker/config.dart';

class SessionInfoForm extends StatelessWidget {
  SessionInfoForm({
    super.key,
    required this.nameController,
    required this.noteController,
    required this.weigthController,
    required this.babyIdController,
    required this.roomNumberController,
    required this.startTime,
    required this.endTimeController,
    required this.sessionVar,
    this.isConfirm = false,
  });

  final TextEditingController nameController;
  final TextEditingController noteController;
  final TextEditingController weigthController;
  final TextEditingController babyIdController;
  final TextEditingController roomNumberController;
  final DateTime startTime;
  late DateTime endTimeController;
  final Session sessionVar;
  final bool isConfirm;

  ValueNotifier<bool> endTimeNotifier = ValueNotifier(true);

  void updateWeigth(int value) {
    int currentValue = int.tryParse(weigthController.text) ?? 0;
    currentValue += value;

    if (currentValue >= 0) {
      weigthController.text = currentValue.toString();
    }
  }

  void updateRoomNumber(int value) {
    int currentValue = int.tryParse(roomNumberController.text) ?? 0;
    currentValue += value;

    if (currentValue >= 1) {
      roomNumberController.text = currentValue.toString();
    }
  }

  Future<void> endTimePopup(context) async {
    TimeOfDay? newEndTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTimeController),
    );

    DateTime tempEndTime = DateTime(
        endTimeController.year,
        endTimeController.month,
        endTimeController.day,
        newEndTime?.hour ?? 0,
        newEndTime?.minute ?? 0);

    endTimeNotifier.notifyListeners();
    if (newEndTime == null) {
      // Cancelled
      return;
    } else if (tempEndTime.isAfter(startTime)) {
      endTimeController = tempEndTime;
      int endTimeMilliseconds = endTimeController.millisecondsSinceEpoch;
      List<List<dynamic>> csvData =
          await csvFromFile("$sessionPath${sessionVar.id}/recordedData.csv");
      List<List<String>> newCsv = [];
      for (int i = 1; i < csvData.length; i++) {
        // Skip the line with column names
        List<String> newCsvLine = [];
        for (int j = 0; j < csvData[i].length; j += 2) {
          // Starts with time and skips over values
          if ((csvData[i][j].runtimeType == int ? csvData[i][j] : 0) >
              endTimeMilliseconds) {
            continue;
          }
          newCsvLine
              .addAll([csvData[i][j].toString(), csvData[i][j + 1].toString()]);
        }
        newCsv.add(newCsvLine);
      }
    } else {
      PopupAndLoading.showError(
          "Datum kan niet ouder zijn dan starttijd (${startTime.hour}:${startTime.minute})");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          title: "Opname gegevens",
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        InputField(
          controller: nameController,
          labelText: "Moeder naam",
          isRequired: isConfirm,
        ),
        const PaddingSpacing(),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Button(
                text: "- 100g",
                onTap: () => updateWeigth(-100),
              ),
            ),
            const PaddingSpacing(),
            Flexible(
              child: InputField(
                controller: weigthController,
                labelText: "Gewicht",
                isInt: true,
              ),
            ),
            const PaddingSpacing(),
            SizedBox(
              width: 100,
              child: Button(
                text: "+ 100g",
                onTap: () => updateWeigth(100),
              ),
            ),
          ],
        ),
        const PaddingSpacing(),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Button(
                text: "- 1",
                onTap: () => updateRoomNumber(-1),
              ),
            ),
            const PaddingSpacing(),
            Flexible(
              child: InputField(
                controller: roomNumberController,
                labelText: "Kamer nummer",
                isInt: true,
              ),
            ),
            const PaddingSpacing(),
            SizedBox(
              width: 100,
              child: Button(
                text: "+ 1",
                onTap: () => updateRoomNumber(1),
              ),
            ),
          ],
        ),
        if (isConfirm) const PaddingSpacing(),
        if (isConfirm)
          InputField(
            isRequired: false,
            controller: babyIdController,
            labelText: "Baby ID",
          ),
        const PaddingSpacing(),
        InputField(
          isRequired: false,
          isMultiLine: true,
          controller: noteController,
          labelText: "Notitie",
        ),
        if (isConfirm) const PaddingSpacing(),
        if (isConfirm)
          Row(
            children: [
              Button(
                  onTap: () async {
                    await endTimePopup(context);
                  },
                  text: "Tijd aanpassen"),
              const PaddingSpacing(),
              ValueListenableBuilder(
                valueListenable: endTimeNotifier,
                builder: ((context, value, child) => Text(
                    "Einde van sessie: ${endTimeController.hour}:${endTimeController.minute}")),
              ),
            ],
          )
      ],
    );
  }
}
