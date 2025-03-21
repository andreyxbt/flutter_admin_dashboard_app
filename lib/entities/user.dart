class User {
  final String userId;
  final String? orgId;  // Make optional
  final String name;
  final String email;
  final String? organizationName;  // Make optional

  User({
    required this.userId,
    this.orgId,  // Make optional
    required this.name,
    required this.email,
    this.organizationName,  // Make optional
  });

  User copyWith({
    String? userId,
    String? orgId,
    String? name,
    String? email,
    String? organizationName,
  }) {
    return User(
      userId: userId ?? this.userId,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      email: email ?? this.email,
      organizationName: organizationName ?? this.organizationName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orgId': orgId,
      'name': name,
      'email': email,
      'organizationName': organizationName,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      orgId: json['orgId'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      organizationName: json['organizationName'] as String?,
    );
  }
}