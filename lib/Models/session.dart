class Session {
  Session({
    required this.id,
    required this.weight,
    this.babyId,
    required this.nameMother,
    required this.birthDateTime,
    required this.endDateTime,
    required this.note,
    required this.roomNumber,
  });
  final String id;
  
  String? babyId;
  int weight;
  String nameMother;
  String note;
  DateTime birthDateTime;
  DateTime endDateTime;
  int roomNumber;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        weight: json['weight'],
        babyId: json['babyId'],
        nameMother: json['nameMother'],
        note: json['note'],
        birthDateTime: DateTime.fromMillisecondsSinceEpoch(json['birthTime']),
        endDateTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
        roomNumber: json['roomNumber'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'nameMother': nameMother,
        'birthTime': birthDateTime.millisecondsSinceEpoch,
        'endTime': endDateTime.millisecondsSinceEpoch,
        'babyId': babyId,
        'note': note,
        'roomNumber': roomNumber
      };
}
