class Session {
  const Session({
    required this.id,
    required this.weight,
    this.babyId,
    required this.nameMother,
    required this.birthTime,
    required this.note,
  });
  final String id;
  final String? babyId;
  final int weight;
  final String nameMother;
  final DateTime birthTime;
  final String note;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        weight: json['weight'],
        babyId: json['babyId'],
        nameMother: json['nameMother'],
        birthTime: DateTime.fromMillisecondsSinceEpoch(json['birthTime']),
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'nameMother': nameMother,
        'birthTime': birthTime.millisecondsSinceEpoch,
        'babyId': babyId,
        'note': note
      };
}
