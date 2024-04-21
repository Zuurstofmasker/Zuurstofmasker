import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Pages/Dashboard/dashboard.dart';
import 'package:zuurstofmasker/config.dart';

void main() {
  // Setting the default styles for the popups

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Maasgroep 18 Applicatie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class PatientFormPage extends StatelessWidget {
  const PatientFormPage ({
    super.key
  });

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form sample')),
        body: const PatientForm(),
      ),
    );
  }
}

class PatientForm extends StatelessWidget {
  const PatientForm({super.key});

  @override
  Widget build(BuildContext context){
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: '0',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '0',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
          ),TextFormField(
            decoration: const InputDecoration(
              hintText: '0',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
          ),TextFormField(
            decoration: const InputDecoration(
              hintText: '0',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
          ),TextFormField(
            decoration: const InputDecoration(
              hintText: '0',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Invalid input!';
              }
              return null;
            },
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
