class SessionDetail {
  SessionDetail(
      {this.id, this.weight, this.nameMother, this.birthTime, this.note});
  int? id;
  int? weight;
  String? nameMother;
  DateTime? birthTime;
  String? note;

  SessionDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        weight = json['weight'] as int,
        nameMother = json['nameMother'] as String,
        // birthTime = json['birthTime'] as DateTime,
        note = json['note'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'nameMother': nameMother,
        // 'birthTime': birthTime,
        'note': note
      };
}
