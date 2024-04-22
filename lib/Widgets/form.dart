import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';

TextEditingController stateOutController = TextEditingController();
TextEditingController biasFlowController = TextEditingController();
TextEditingController patientFlowController = TextEditingController();
TextEditingController fiO2Controller = TextEditingController();
TextEditingController vtiController = TextEditingController();
TextEditingController vteController = TextEditingController();

class PatientForm extends StatefulWidget {
  const PatientForm ({
    super.key
  });

  @override
  State<PatientForm> createState() => _PatientFormState(); 
}

class _PatientFormState extends State<PatientForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InputField(
            controller: stateOutController,
            hintText: "State OUT",
            isDouble: true,
          ),
          InputField(
            controller: biasFlowController,
            hintText: "Bias flow",
            isDouble: true,
          ),
          InputField(
            controller: patientFlowController,
            hintText: "Patient flow",
            isDouble: true,
          ),
          InputField(
            controller: fiO2Controller,
            hintText: "FiO2",
            isDouble: true,
          ),
          InputField(
            controller: vtiController,
            hintText: "Vti",
            isDouble: true,
          ),
          InputField(
            controller: vteController,
            hintText: "Vte",
            isDouble: true,
          ),
        ],
      ),
    );
  }
}