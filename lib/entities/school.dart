import 'organization.dart';

class School extends Organization {
  final List<String> userIds;

  School({
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
  School copyWith({
    String? id,
    String? name,
    String? description,
    String? users,
    String? courses,
    String? reports,
    String? lastUpdated,
    List<String>? userIds,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
      courses: courses ?? this.courses,
      reports: reports ?? this.reports,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      userIds: userIds ?? this.userIds,
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

  int get userCount => userIds.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is School && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}