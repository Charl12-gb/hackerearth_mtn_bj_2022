import 'package:hackerearth_mtn_bj_2022/models/enums.dart';

class User{
  final String id;
  final String name;
  final String phoneNumber;
  final UserRole role;
  final int createdAt;
  final int updatedAt;
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  User copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    UserRole? role,
    int? createdAt,
    int? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'phoneNumber': this.phoneNumber,
      'role': this.role,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'metadata': this.metadata,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      role: map['role'] as UserRole,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      metadata: map['metadata'] as Map<String, dynamic>,
    );
  }
}