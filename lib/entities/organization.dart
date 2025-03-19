class Organization {
  final String name;
  final String description;
  final String users;
  final String courses;
  final String lessons;
  final String quizzes;
  final String assignments;
  final String reports;
  final String lastUpdated;

  Organization({
    required this.name,
    this.description = '',
    required this.users,
    required this.courses,
    required this.lessons,
    required this.quizzes,
    required this.assignments,
    required this.reports,
    required this.lastUpdated,
  });

  Organization copyWith({
    String? name,
    String? description,
    String? users,
    String? courses,
    String? lessons,
    String? quizzes,
    String? assignments,
    String? reports,
    String? lastUpdated,
  }) {
    return Organization(
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
      courses: courses ?? this.courses,
      lessons: lessons ?? this.lessons,
      quizzes: quizzes ?? this.quizzes,
      assignments: assignments ?? this.assignments,
      reports: reports ?? this.reports,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}