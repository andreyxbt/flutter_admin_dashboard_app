import 'dart:convert';
import '../entities/school.dart';
import '../services/shared_preferences_service.dart';

abstract class SchoolRepository {
  Future<List<School>> getSchools();
  Future<void> addSchool(School school);
  Future<void> updateSchool(School school);
  Future<void> deleteSchool(String id);
}

class PersistentSchoolRepository implements SchoolRepository {
  static const String _storageKey = 'schools';
  final SharedPreferencesService _prefsService;
  
  PersistentSchoolRepository(this._prefsService) {
    _initializeDefaultData();
  }

  Future<void> _initializeDefaultData() async {
    if (_prefsService.getString(_storageKey) == null) {
      final defaultSchools = [
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
      ];
      
      await _saveSchools(defaultSchools);
    }
  }

  Future<void> _saveSchools(List<School> schools) async {
    final jsonData = schools.map((school) => school.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonData));
  }

  @override
  Future<List<School>> getSchools() async {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr == null) return [];
    
    final jsonData = jsonDecode(jsonStr) as List;
    return jsonData.map((json) => School.fromJson(json)).toList();
  }

  @override
  Future<void> addSchool(School school) async {
    final schools = await getSchools();
    schools.add(school);
    await _saveSchools(schools);
  }

  @override
  Future<void> updateSchool(School school) async {
    final schools = await getSchools();
    final index = schools.indexWhere((s) => s.id == school.id);
    if (index != -1) {
      schools[index] = school;
      await _saveSchools(schools);
    }
  }

  @override
  Future<void> deleteSchool(String id) async {
    final schools = await getSchools();
    schools.removeWhere((school) => school.id == id);
    await _saveSchools(schools);
  }
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