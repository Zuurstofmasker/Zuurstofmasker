import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Pages/StartSession/sessionInfoForm.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';

// ignore: must_be_immutable
class ConfirmSession extends StatelessWidget {
  ConfirmSession({super.key, required this.session});

  final Session session;
  late TextEditingController nameController =
      TextEditingController(text: session.nameMother);
  late TextEditingController noteController =
      TextEditingController(text: session.note);
  late TextEditingController weigthController =
      TextEditingController(text: session.weight.toString());
  late TextEditingController babyIdController =
      TextEditingController(text: session.babyId);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> saveSessionData() async {
    if (!formKey.currentState!.validate()) return;

    PopupAndLoading.showLoading();

    session.nameMother = nameController.text;
    session.note = noteController.text;
    session.weight = int.parse(weigthController.text);
    session.babyId = babyIdController.text;

    await updateSession(session).then(
      (value) {
        replaceAllPages(
            MaterialPageRoute(builder: (context) => const Dashboard()));
        PopupAndLoading.showSuccess("Opvang informatie opslaan gelukt");
      },
    ).catchError((error) {
      PopupAndLoading.showError("Opvang informatie opslaan mislukt");
    });

    PopupAndLoading.endLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
      child: Padding(
        padding: pagePadding,
        child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SessionInfoForm(
              nameController: nameController,
              noteController: noteController,
              weigthController: weigthController,
              babyIdController: babyIdController,
              isConfirm: true,
            ),
            const PaddingSpacing(
              multiplier: 2,
            ),
            Button(
              text: "Informatie opslaan",
              onTap: saveSessionData,
            )
          ]),
        ),
      ),
    );
  }
}
