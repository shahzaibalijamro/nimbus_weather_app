// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str)["user"]);

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "createdAt": createdAt.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final loginError = loginErrorFromJson(jsonString);

LoginError loginErrorFromJson(String str) => LoginError.fromJson(json.decode(str)["error"]);

class LoginError {
  final String code;
  final String message;

  LoginError({
    required this.code,
    required this.message,
  });

  factory LoginError.fromJson(Map<String, dynamic> json) => LoginError(
    code: json["code"],
    message: json["message"],
  );
}
