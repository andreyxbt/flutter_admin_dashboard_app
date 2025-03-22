import 'organization.dart';

class ContentDirector {
  final String userId;
  final String? orgId;
  final String name;
  final String email;
  final String? organizationName;
  final String role;
  final List<String> assignedCourses;

  ContentDirector({
    required this.userId,
    this.orgId,
    required this.name,
    required this.email,
    this.organizationName,
    this.role = 'Content Director',
    List<String>? assignedCourses,
  }) : assignedCourses = assignedCourses ?? [];

  ContentDirector copyWith({
    String? userId,
    String? orgId,
    String? name,
    String? email,
    String? organizationName,
    String? role,
    List<String>? assignedCourses,
  }) {
    return ContentDirector(
      userId: userId ?? this.userId,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      email: email ?? this.email,
      organizationName: organizationName ?? this.organizationName,
      role: role ?? this.role,
      assignedCourses: assignedCourses ?? this.assignedCourses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orgId': orgId,
      'name': name,
      'email': email,
      'organizationName': organizationName,
      'role': role,
      'assignedCourses': assignedCourses,
    };
  }

  factory ContentDirector.fromJson(Map<String, dynamic> json) {
    return ContentDirector(
      userId: json['userId'] as String,
      orgId: json['orgId'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      organizationName: json['organizationName'] as String?,
      role: json['role'] as String? ?? 'Content Director',
      assignedCourses: List<String>.from(json['assignedCourses'] ?? []),
    );
  }
}