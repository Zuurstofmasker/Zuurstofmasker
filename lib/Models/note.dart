class Note {
  const Note(
      {required this.id,
      required this.time,
      required this.title,
      required this.description});
  final String id;
  final Duration time;
  final String title;
  final String description;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        time: Duration(milliseconds: json['noteTime']),
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'noteTime': time.inMilliseconds,
        'title': title,
        'description': description,
      };
}
