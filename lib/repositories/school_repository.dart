import '../entities/school.dart';

abstract class SchoolRepository {
  Future<List<School>> getSchools();
  Future<void> addSchool(School school);
  Future<void> updateSchool(School school);
  Future<void> deleteSchool(String id);
}

class InMemorySchoolRepository implements SchoolRepository {
  final List<School> _schools = [
    School(
      id: '1',
      name: 'Acme High School',
      description: 'Leading high school for cartoon physics',
      users: '150',
      courses: '25',
      reports: '45',
      lastUpdated: '2023-12-01',
    ),
    School(
      id: '2',
      name: 'Springfield Elementary',
      description: 'Elementary school with character',
      users: '200',
      courses: '15',
      reports: '30',
      lastUpdated: '2023-12-02',
    ),
    // Add more initial schools as needed
  ];

  @override
  Future<List<School>> getSchools() async => List.from(_schools);

  @override
  Future<void> addSchool(School school) async {
    _schools.add(school);
  }

  @override
  Future<void> updateSchool(School school) async {
    final index = _schools.indexWhere((s) => s.id == school.id);
    if (index != -1) {
      _schools[index] = school;
    }
  }

  @override
  Future<void> deleteSchool(String id) async {
    _schools.removeWhere((school) => school.id == id);
  }
}