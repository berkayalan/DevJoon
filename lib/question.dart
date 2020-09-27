import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String question;
  String answer;
  String imageUrl;
  Timestamp createdAt;
  Question({
    this.question,
    this.answer,
    this.imageUrl,
    this.createdAt,
  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        question: json['question'],
        answer: json['answer'],
        imageUrl: json['imageUrl'],
        createdAt: json['createdAt']);
  }
  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..addAll({
      'question': this.question,
      'answer': this.answer,
      'imageUrl': this.imageUrl,
      'createdAt': FieldValue.serverTimestamp()
    });
}
