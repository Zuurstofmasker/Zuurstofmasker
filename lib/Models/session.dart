class Session {
  Session({
    required this.id,
    required this.weight,
    this.babyId,
    required this.nameMother,
    required this.birthTime,
    required this.endTime,
    required this.note,
    required this.roomNumber,
  });
  final String id;
  
  String? babyId;
  int weight;
  String nameMother;
  String note;
  DateTime birthTime;
  DateTime endTime;
  int roomNumber;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        weight: json['weight'],
        babyId: json['babyId'],
        nameMother: json['nameMother'],
        note: json['note'],
        birthTime: DateTime.fromMillisecondsSinceEpoch(json['birthTime']),
        endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
        roomNumber: json['roomNumber'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'nameMother': nameMother,
        'birthTime': birthTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
        'babyId': babyId,
        'note': note,
        'roomNumber': roomNumber
      };
}
