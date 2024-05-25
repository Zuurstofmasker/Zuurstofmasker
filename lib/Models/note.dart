class Note {
  const Note(
      {required this.id,
      required this.noteTime,
      required this.title,
      required this.description});
  final String id;
  final Duration noteTime;
  final String title;
  final String description;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        noteTime: Duration(milliseconds: json['noteTime']),
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'noteTime': noteTime.inMilliseconds,
        'title': title,
        'description': description,
      };
}
