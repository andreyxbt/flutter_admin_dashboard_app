import 'organization.dart';

class School extends Organization {
  School({
    required super.id,
    required super.name,
    super.description,
    required super.users,
    required super.courses,
    required super.reports,
    required super.lastUpdated,
  });

  @override
  School copyWith({
    String? id,
    String? name,
    String? description,
    String? users,
    String? courses,
    String? reports,
    String? lastUpdated,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
      courses: courses ?? this.courses,
      reports: reports ?? this.reports,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}