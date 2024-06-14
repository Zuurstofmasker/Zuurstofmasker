import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';

// ignore: must_be_immutable
class SessionInfoForm extends StatelessWidget {
  SessionInfoForm.start({
    super.key,
    required this.nameController,
    required this.noteController,
    required this.weigthController,
    required this.babyIdController,
    required this.roomNumberController,
  })  : isConfirm = false,
        endTimeValidator = null,
        onEndTimePick = null,
        endTimeController = null,
        birthTimeController = null;

  SessionInfoForm.confirm({
    super.key,
    required this.nameController,
    required this.noteController,
    required this.weigthController,
    required this.babyIdController,
    required this.roomNumberController,
    required this.endTimeController,
    required this.birthTimeController,
    required this.onEndTimePick,
    required this.endTimeValidator,
  }) : isConfirm = true;

  final TextEditingController nameController;
  final TextEditingController noteController;
  final TextEditingController weigthController;
  final TextEditingController babyIdController;
  final TextEditingController roomNumberController;
  final TextEditingController? endTimeController;
  final TextEditingController? birthTimeController;
  final Function()? onEndTimePick;
  final String? Function()? endTimeValidator;
  final bool isConfirm;

  ValueNotifier<bool> endTimeNotifier = ValueNotifier(true);

  void updateWeigth(int value) {
    int currentValue = int.tryParse(weigthController.text) ?? 0;
    currentValue += value;

    if (currentValue < 800 || currentValue > 6000) return;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          title: "Opvanggegevens",
        ),
        const PaddingSpacing(
          multiplier: 2,
        ),
        InputField(
          controller: nameController,
          labelText: "Naam moeder",
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
                labelText: "Kamernummer",
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
        if (isConfirm) ...[
          const PaddingSpacing(),
          InputField(
            isRequired: false,
            controller: babyIdController,
            labelText: "Patiënt ID",
          ),
          const PaddingSpacing(),
          InputField(
            labelText: "Geboortetijd",
            icon: Icons.timer,
            isReadOnly: true,
            controller: birthTimeController,
          ),
          const PaddingSpacing(),
          InputField(
            icon: Icons.timer,
            labelText: "Eindtijd",
            isReadOnly: true,
            controller: endTimeController,
            validator: (p0) {
              if (endTimeValidator != null) {
                return endTimeValidator!();
              }
              return null;
            },
            onTap: () {
              if (onEndTimePick != null) {
                onEndTimePick!();
              }
            },
          ),
        ],
        const PaddingSpacing(),
        InputField(
          isRequired: false,
          isMultiLine: true,
          controller: noteController,
          labelText: "Notitie",
        ),
      ],
    );
  }
}
