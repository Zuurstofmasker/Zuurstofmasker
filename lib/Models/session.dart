class Session {
  const Session({
    required this.id,
    required this.weight,
    this.babyId,
    required this.nameMother,
    required this.birthTime,
    required this.note,
    this.stateOutFlow = 0,
    this.biasFlow = 0,
    this.patientFlow = 0,
    this.fiO2 = 0,
    this.vti = 0,
    this.vte = 0,
  });
  final String id;
  final String? babyId;
  final int weight;
  final String nameMother;
  final DateTime birthTime;
  final String note;
  final double stateOutFlow;
  final double biasFlow;
  final double patientFlow;
  final double fiO2;
  final double vti;
  final double vte;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        weight: json['weight'],
        babyId: json['babyId'],
        nameMother: json['nameMother'],
        birthTime: DateTime.fromMillisecondsSinceEpoch(json['birthTime']),
        note: json['note'],
        stateOutFlow: json['stateOutFlow'],
        biasFlow: json['biasFlow'],
        patientFlow: json['patientFlow'],
        fiO2: json['fiO2'],
        vti: json['vti'],
        vte: json['vte']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'nameMother': nameMother,
        'birthTime': birthTime.millisecondsSinceEpoch,
        'babyId': babyId,
        'note': note,
        'stateOutFlow': stateOutFlow,
        'biasFlow': biasFlow,
        'patientFlow': patientFlow,
        'fiO2': fiO2,
        'vti': vti,
        'vte': vte
      };
}
