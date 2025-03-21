import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

class CachedSchoolRepository implements SchoolRepository {
  static const String _cacheKey = 'cached_schools';
  final SharedPreferences _prefs;
  List<School> _cachedSchools = [];

  CachedSchoolRepository(this._prefs) {
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedSchools = jsonList.map((json) => _schoolFromJson(json)).toList();
    } else {
      // Initialize with default data if cache is empty
      _cachedSchools = [
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
      await _saveToCache();
    }
  }

  Future<void> _saveToCache() async {
    final jsonList = _cachedSchools.map((school) => _schoolToJson(school)).toList();
    await _prefs.setString(_cacheKey, json.encode(jsonList));
  }

  Map<String, dynamic> _schoolToJson(School school) {
    return {
      'id': school.id,
      'name': school.name,
      'description': school.description,
      'users': school.users,
      'courses': school.courses,
      'reports': school.reports,
      'lastUpdated': school.lastUpdated,
      'userIds': school.userIds,
    };
  }

  School _schoolFromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      users: json['users'],
      courses: json['courses'],
      reports: json['reports'],
      lastUpdated: json['lastUpdated'],
      userIds: List<String>.from(json['userIds'] ?? []),
    );
  }

  @override
  Future<List<School>> getSchools() async {
    return List.from(_cachedSchools);
  }

  @override
  Future<void> addSchool(School school) async {
    _cachedSchools.add(school);
    await _saveToCache();
  }

  @override
  Future<void> updateSchool(School school) async {
    final index = _cachedSchools.indexWhere((s) => s.id == school.id);
    if (index != -1) {
      _cachedSchools[index] = school;
      await _saveToCache();
    }
  }

  @override
  Future<void> deleteSchool(String id) async {
    _cachedSchools.removeWhere((school) => school.id == id);
    await _saveToCache();
  }
}