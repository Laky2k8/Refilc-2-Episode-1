import 'dart:convert';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/models/school.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:uuid/uuid.dart';

enum Role { student, parent }

class User {
  late String id;
  String username;
  String password;
  String instituteCode;
  String name;
  Student student;
  Role role;
  String nickname;
  String picture;

  String get displayName => nickname != '' ? nickname : name;

  User({
    String? id,
    required this.name,
    required this.username,
    required this.password,
    required this.instituteCode,
    required this.student,
    required this.role,
    this.nickname = "",
    this.picture = "",
  }) {
    if (id != null) {
      this.id = id;
    } else {
      this.id = const Uuid().v4();
    }
  }

  factory User.fromMap(Map map) {
    return User(
      id: map["id"],
      instituteCode: map["institute_code"],
      username: map["username"],
      password: map["password"],
      name: map["name"].trim(),
      student: map["student"] != 'null'
          ? Student.fromJson(jsonDecode(map["student"]))
          : Student(
              id: const Uuid().v4(),
              name: 'Ismeretlen Diák',
              school: School(instituteCode: '', name: '', city: ''),
              birth: DateTime.now(),
              yearId: '1',
              parents: [],
            ),
      role: Role.values[map["role"] ?? 0],
      nickname: map["nickname"] ?? "",
      picture: map["picture"] ?? "",
    );
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "institute_code": instituteCode,
      "name": name,
      "student": jsonEncode(student.json),
      "role": role.index,
      "nickname": nickname,
      "picture": picture,
    };
  }

  @override
  String toString() => jsonEncode(toMap());

  static Map<String, Object?> loginBody({
    required String username,
    required String password,
    required String instituteCode,
  }) {
    return {
      "userName": username,
      "password": password,
      "institute_code": instituteCode,
      "grant_type": "password",
      "client_id": KretaAPI.clientId,
    };
  }

  static Map<String, Object?> refreshBody({
    required String refreshToken,
    required String instituteCode,
  }) {
    return {
      "refresh_token": refreshToken,
      "institute_code": instituteCode,
      "client_id": KretaAPI.clientId,
      "grant_type": "refresh_token",
      "refresh_user_data": "false",
    };
  }

  static Map<String, Object?> logoutBody({
    required String refreshToken,
  }) {
    return {
      "refresh_token": refreshToken,
      "client_id": KretaAPI.clientId,
    };
  }
}
