import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';

TextEditingController stateOutController = TextEditingController(text:"0");
TextEditingController biasFlowController = TextEditingController(text:"0");
TextEditingController patientFlowController = TextEditingController(text:"0");
TextEditingController fiO2Controller = TextEditingController(text:"0");
TextEditingController vtiController = TextEditingController(text:"0");
TextEditingController vteController = TextEditingController(text:"0");

class PatientForm extends StatelessWidget {
  const PatientForm ({
    super.key
  });

  @override
  Widget build(BuildContext context){
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InputField(
            controller: stateOutController,
            hintText: "State OUT",
            isDouble: true,
            labelText: "State OUT",
          ),
          InputField(
            controller: biasFlowController,
            hintText: "Bias flow",
            isDouble: true,
            labelText: "Bias flow",
          ),
          InputField(
            controller: patientFlowController,
            hintText: "Patient flow",
            isDouble: true,
            labelText: "Patient flow",
          ),
          InputField(
            controller: fiO2Controller,
            hintText: "FiO2",
            isDouble: true,
            labelText: "Fi02",
          ),
          InputField(
            controller: vtiController,
            hintText: "Vti",
            isDouble: true,
            labelText: "Vti",
          ),
          InputField(
            controller: vteController,
            hintText: "Vte",
            isDouble: true,
            labelText: "Vte",
          ),
        ],
      ),
    );
  }
}