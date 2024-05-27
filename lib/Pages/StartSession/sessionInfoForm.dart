import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';

class SessionInfoForm extends StatelessWidget {
  SessionInfoForm({
    super.key,
    required this.nameController,
    required this.noteController,
    required this.weigthController,
    required this.babyIdController,
    this.isConfirm = false,
  });

  final TextEditingController nameController;
  final TextEditingController noteController;
  final TextEditingController weigthController;
  final TextEditingController babyIdController;
  final bool isConfirm;

  void updateWeigth(int value) {
    int currentValue = int.tryParse(weigthController.text) ?? 0;
    currentValue += value;

    if(currentValue >= 0){
      weigthController.text = currentValue.toString();
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
      ],
    );
  }
}
