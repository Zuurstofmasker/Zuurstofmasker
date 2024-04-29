abstract class JsonHelper {
  Map<String, dynamic> toJson();
}

class User implements JsonHelper {
  final String name;
  final int id;
  final int age;

  User({required this.age, required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(age: json['age'], id: json['id'], name: json['name']);
  }

  @override
  Map<String, dynamic> toJson() => {'name': name, 'id': id, 'age': age};
}
