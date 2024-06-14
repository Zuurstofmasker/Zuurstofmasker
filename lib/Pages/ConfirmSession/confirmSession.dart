import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/dateAndTimeHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/session.dart';
import 'package:zuurstofmasker/Models/sessionSerialData.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/Pages/StartSession/Parts/sessionInfoForm.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';

// ignore: must_be_immutable
class ConfirmSession extends StatelessWidget {
  ConfirmSession({
    super.key,
    required this.session,
    required this.serialData,
  });

  final Session session;
  final SessionSerialData serialData;
  late TextEditingController nameController =
      TextEditingController(text: session.nameMother);
  late TextEditingController noteController =
      TextEditingController(text: session.note);
  late TextEditingController weigthController =
      TextEditingController(text: session.weight.toString());
  late TextEditingController babyIdController =
      TextEditingController(text: session.babyId);
  late TextEditingController roomNumberController =
      TextEditingController(text: session.roomNumber.toString());
  late TextEditingController endTimeController = TextEditingController(
    text: formatTimeOfDay(TimeOfDay.fromDateTime(session.endDateTime)),
  );
  late TextEditingController birthTimeController = TextEditingController(
    text: formatTimeOfDay(TimeOfDay.fromDateTime(session.birthDateTime)),
  );

  late TimeOfDay endTime = TimeOfDay.fromDateTime(session.endDateTime);
  DateTime get endDateTime =>
      setTimeOfDayOfDateTime(session.endDateTime, endTime);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> saveSessionData() async {
    if (!formKey.currentState!.validate()) return;

    PopupAndLoading.showLoading();

    session.nameMother = nameController.text;
    session.note = noteController.text;
    session.weight = int.parse(weigthController.text);
    session.babyId = babyIdController.text;
    session.endDateTime = endDateTime;

    bool serialDataError = false;

    if (TimeOfDay.fromDateTime(endDateTime) != endTime) {
      serialData.cutDataFrom(endDateTime);

      await serialData.saveToFile(session.id).catchError((error) {
        serialDataError = true;
        PopupAndLoading.showError("Seriële data opslaan mislukt");
      });
    }

    if (!serialDataError) {
      await updateSession(session).then(
        (value) {
          replaceAllPages(
              MaterialPageRoute(builder: (context) => const Dashboard()));
          PopupAndLoading.showSuccess("Opvang informatie opslaan gelukt");
        },
      ).catchError((error) {
        PopupAndLoading.showError("Opvang informatie opslaan mislukt");
      });
    }

    PopupAndLoading.endLoading();
  }

  Future<void> endTimePopup(context) async {
    TimeOfDay? newEndTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (newEndTime != null) {
      endTime = newEndTime;
      endTimeController.text = formatTimeOfDay(endTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
      child: SingleChildScrollView(
        padding: pagePadding,
        child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SessionInfoForm.confirm(
              nameController: nameController,
              noteController: noteController,
              weigthController: weigthController,
              babyIdController: babyIdController,
              roomNumberController: roomNumberController,
              endTimeController: endTimeController,
              birthTimeController: birthTimeController,
              onEndTimePick: () async {
                await endTimePopup(context);
              },
              endTimeValidator: () {
                if (endDateTime.isAfter(session.endDateTime)) {
                  return "Eindtijd mag niet later dan ${formatTimeOfDay(TimeOfDay.fromDateTime(session.endDateTime))} worden ingesteld";
                } else if (endDateTime.isBefore(dateTimeMinutePresicion(session.birthDateTime))) {
                  return "Eindtijd mag niet voor de geboortedatum worden ingesteld";
                }
                return null;
              },
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
