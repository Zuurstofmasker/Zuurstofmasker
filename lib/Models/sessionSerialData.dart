import 'package:zuurstofmasker/Widgets/form.dart';

class SessionSerialData {
  const SessionSerialData({
    required this.sessionId,
    required this.seconds,
    required this.stateOutFlow,
    required this.biasFlow,
    required this.patientFlow,
    required this.fiO2,
    required this.vti,
    required this.vte,
  });
  final String sessionId;
  final List<double> seconds;
  final List<double> stateOutFlow;
  final List<double> biasFlow;
  final List<double> patientFlow;
  final List<double> fiO2;
  final List<double> vti;
  final List<double> vte;

  List<List<double>> get csvData => List<List<double>>.of({seconds,stateOutFlow, biasFlow, patientFlow, fiO2, vti, vte});

  factory SessionSerialData.fromCsv(List<List<double>> csv, String name) => SessionSerialData(
    sessionId: name, 
    seconds: csv[0], 
    stateOutFlow: csv[1], 
    biasFlow: csv[2], 
    patientFlow: csv[3], 
    fiO2: csv[4], 
    vti: csv[5], 
    vte: csv[6]
    );
}