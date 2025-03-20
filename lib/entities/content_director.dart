class ContentDirector {
  final String userId;
  final String orgId;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContentDirector({
    required this.userId,
    required this.orgId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  ContentDirector copyWith({
    String? userId,
    String? orgId,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContentDirector(
      userId: userId ?? this.userId,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}