class Teacher {
  final String userId;
  final String? orgId;
  final String name;
  final String email;
  final String? organizationName;
  final String role;
  final List<String> assignedCourses;
  final List<String> students;

  Teacher({
    required this.userId,
    this.orgId,
    required this.name,
    required this.email,
    this.organizationName,
    this.role = 'Teacher',
    List<String>? assignedCourses,
    List<String>? students,
  }) : assignedCourses = assignedCourses ?? [],
       students = students ?? [];

  Teacher copyWith({
    String? userId,
    String? orgId,
    String? name,
    String? email,
    String? organizationName,
    String? role,
    List<String>? assignedCourses,
    List<String>? students,
  }) {
    return Teacher(
      userId: userId ?? this.userId,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      email: email ?? this.email,
      organizationName: organizationName ?? this.organizationName,
      role: role ?? this.role,
      assignedCourses: assignedCourses ?? this.assignedCourses,
      students: students ?? this.students,
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
      'students': students,
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      userId: json['userId'] as String,
      orgId: json['orgId'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      organizationName: json['organizationName'] as String?,
      role: json['role'] as String? ?? 'Teacher',
      assignedCourses: List<String>.from(json['assignedCourses'] ?? []),
      students: List<String>.from(json['students'] ?? []),
    );
  }
}