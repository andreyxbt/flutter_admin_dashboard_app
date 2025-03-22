import 'organization.dart';

class PDCompany extends Organization {
  final List<String> userIds;

  PDCompany({
    required super.id,
    required super.name,
    super.description,
    required super.users,
    required super.courses,
    required super.reports,
    required super.lastUpdated,
    List<String>? userIds,
  }) : userIds = userIds ?? [];

  @override
  PDCompany copyWith({
    String? id,
    String? name,
    String? description,
    String? users,
    String? courses,
    String? reports,
    String? lastUpdated,
    List<String>? userIds,
  }) {
    return PDCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
      courses: courses ?? this.courses,
      reports: reports ?? this.reports,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      userIds: userIds ?? List.from(this.userIds),
    );
  }

  void addUser(String userId) {
    if (!userIds.contains(userId)) {
      userIds.add(userId);
    }
  }

  void removeUser(String userId) {
    userIds.remove(userId);
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'userIds': userIds,
    };
  }

  factory PDCompany.fromJson(Map<String, dynamic> json) {
    return PDCompany(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      users: json['users'] as String,
      courses: json['courses'] as String,
      reports: json['reports'] as String,
      lastUpdated: json['lastUpdated'] as String,
      userIds: List<String>.from(json['userIds'] ?? []),
    );
  }
}