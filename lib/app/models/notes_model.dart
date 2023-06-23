// import 'dart:convert';

class NotesModel {
  final int? id;
  final String title;
  final int age;
  final String description;
  final String email;

  NotesModel({
    this.id,
    required this.title,
    required this.age,
    required this.description,
    required this.email,
  });

  NotesModel copyWith({
    int? id,
    String? title,
    int? age,
    String? description,
    String? email,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      age: age ?? this.age,
      description: description ?? this.description,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'age': age,
      'description': description,
      'email': email,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> res) {
    return NotesModel(
      id: res['id'] != null ? res['id'] as int : null,
      title: res['title'] as String,
      age: res['age'] as int,
      description: res['description'] as String,
      email: res['email'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory NotesModel.fromJson(String source) =>
  //     NotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotesModel(id: $id, title: $title, age: $age, description: $description, email: $email)';
  }
}
