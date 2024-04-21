import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

void main() async {
  runApp(const Settings());
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  // This widget is the root of your application.
  @override  
  Widget build(BuildContext context) {
    return Nav(
      child: const PatientForm(),
    );
  }
}

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
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'State OUT',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Bias flow',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Patient flow',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'FiO2',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Vti',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Vti',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Vte',
                  ),
                ),
              ],
            ),
            ),
              hintText: '0',
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
