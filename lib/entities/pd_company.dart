import 'organization.dart';

class PDCompany extends Organization {
  PDCompany({
    required super.id,
    required super.name,
    super.description,
    required super.users,
    required super.courses,
    required super.reports,
    required super.lastUpdated,
  });

  @override
  PDCompany copyWith({
    String? id,
    String? name,
    String? description,
    String? users,
    String? courses,
    String? reports,
    String? lastUpdated,
  }) {
    return PDCompany(
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