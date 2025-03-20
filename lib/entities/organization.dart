class Organization {
  final String id;
  final String name;
  final String description;
  final String users;
  final String courses;
  final String reports;
  final String lastUpdated;

  Organization({
    required this.id,
    required this.name,
    this.description = '',
    required this.users,
    required this.courses,
    required this.reports,
    required this.lastUpdated,
  });

  Organization copyWith({
    String? id,
    String? name,
    String? description,
    String? users,
    String? courses,
    String? reports,
    String? lastUpdated,
  }) {
    return Organization(
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

class School extends Organization {
  School({
    required String id,
    required String name,
    String description = '',
    required String users,
    required String courses,
    required String reports,
    required String lastUpdated,
  }) : super(
          id: id,
          name: name,
          description: description,
          users: users,
          courses: courses,
          reports: reports,
          lastUpdated: lastUpdated,
        );

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

class PDCompany extends Organization {
  PDCompany({
    required String id,
    required String name,
    String description = '',
    required String users,
    required String courses,
    required String reports,
    required String lastUpdated,
  }) : super(
          id: id,
          name: name,
          description: description,
          users: users,
          courses: courses,
          reports: reports,
          lastUpdated: lastUpdated,
        );

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