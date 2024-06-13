import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/titles.dart';

class PatientForm extends StatelessWidget {
  const PatientForm({
    super.key,
    required this.stateOutController,
    required this.biasFlowController,
    required this.patientFlowController,
    required this.fiO2Controller,
    required this.vtiController,
    required this.vteController,
  });

  final TextEditingController stateOutController;
  final TextEditingController biasFlowController;
  final TextEditingController patientFlowController;
  final TextEditingController fiO2Controller;
  final TextEditingController vtiController;
  final TextEditingController vteController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const PageTitle(
            title: "Kalibratiegegevens",
          ),
          const PaddingSpacing(
            multiplier: 2,
          ),
          InputField(
            controller: stateOutController,
            isDouble: true,
            labelText: "State OUT",
          ),
          const PaddingSpacing(),
          InputField(
            controller: biasFlowController,
            isDouble: true,
            labelText: "Bias flow",
          ),
          const PaddingSpacing(),
          InputField(
            controller: patientFlowController,
            isDouble: true,
            labelText: "Patient flow",
          ),
          const PaddingSpacing(),
          InputField(
            controller: fiO2Controller,
            isDouble: true,
            labelText: "Fi02",
          ),
          const PaddingSpacing(),
          InputField(
            controller: vtiController,
            isDouble: true,
            labelText: "Vti",
          ),
          const PaddingSpacing(),
          InputField(
            controller: vteController,
            isDouble: true,
            labelText: "Vte",
          ),
        ],
      ),
    );
  }
}
