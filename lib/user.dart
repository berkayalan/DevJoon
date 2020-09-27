import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String question1;
  String question2;
  String question3;
  String question4;
  Timestamp createdAt;
  User(
      {this.id,
      this.question1,
      this.question2,
      this.question3,
      this.question4,
      this.createdAt,});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        question1: json['question1'],
        question2: json['question2'],
        question3: json['question3'],
        question4: json['question4'],
        createdAt: json['createdAt']);
  }
  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..addAll({
      'id': this.id,
      'question1': this.question1,
      'question2': this.question2,
      'question3': this.question3,
      'question4': this.question4,
      'createdAt': FieldValue.serverTimestamp()
    });
}
