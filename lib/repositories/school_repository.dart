import 'dart:convert';
import '../entities/school.dart';
import '../services/shared_preferences_service.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

abstract class SchoolRepository implements BaseRepository<School> {
  Future<List<School>> getSchools();
  Future<School?> getSchool(String id);
  Future<String> addSchool(School school);
  Future<void> updateSchool(School school);
  Future<void> deleteSchool(String id);
}

class PersistentSchoolRepository implements SchoolRepository {
  static const String _storageKey = 'schools';
  final SharedPreferencesService _prefsService;
  final FirestoreSchoolRepository _firebaseRepo;
  List<School> _cachedSchools = [];
  bool _initialized = false;

  PersistentSchoolRepository(this._prefsService, this._firebaseRepo);

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _loadFromCache();
      _initialized = true;
    }
  }

  Future<void> _loadFromCache() async {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr != null) {
      final jsonList = jsonDecode(jsonStr) as List;
      _cachedSchools = jsonList.map((json) => School.fromJson(json)).toList();
    }
  }

  Future<void> _saveToCache(List<School> schools) async {
    final jsonList = schools.map((school) => school.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
    _cachedSchools = schools;
  }

  @override
  Future<List<School>> getSchools() async {
    try {
      final schools = await _firebaseRepo.getAll();
      await _saveToCache(schools);
      return schools;
    } catch (e) {
      await _ensureInitialized();
      return List.from(_cachedSchools);
    }
  }

  @override
  Future<School?> getSchool(String id) async {
    try {
      final school = await _firebaseRepo.getById(id);
      if (school != null) {
        await _ensureInitialized();
        final index = _cachedSchools.indexWhere((s) => s.id == id);
        if (index >= 0) {
          _cachedSchools[index] = school;
        } else {
          _cachedSchools.add(school);
        }
        await _saveToCache(_cachedSchools);
      }
      return school;
    } catch (e) {
      await _ensureInitialized();
      return _cachedSchools.firstWhereOrNull((s) => s.id == id);
    }
  }

  @override
  Future<String> addSchool(School school) async {
    final id = await _firebaseRepo.add(school);
    school = school.copyWith(id: id);
    await _ensureInitialized();
    _cachedSchools.add(school);
    await _saveToCache(_cachedSchools);
    return id;
  }

  @override
  Future<void> updateSchool(School school) async {
    await _firebaseRepo.update(school.id, school);
    await _ensureInitialized();
    final index = _cachedSchools.indexWhere((s) => s.id == school.id);
    if (index >= 0) {
      _cachedSchools[index] = school;
      await _saveToCache(_cachedSchools);
    }
  }

  @override
  Future<void> deleteSchool(String id) async {
    await _firebaseRepo.delete(id);
    await _ensureInitialized();
    _cachedSchools.removeWhere((s) => s.id == id);
    await _saveToCache(_cachedSchools);
  }

  @override
  Future<void> clearCache() async {
    await _prefsService.remove(_storageKey);
    _cachedSchools.clear();
    _initialized = false;
  }

  @override
  Future<List<School>> refreshFromRemote() async {
    final schools = await _firebaseRepo.getAll();
    await _saveToCache(schools);
    return schools;
  }

  @override
  Future<String> add(School item) => _firebaseRepo.add(item);

  @override
  Future<void> delete(String id) => deleteSchool(id);

  @override
  Future<List<School>> getAll() => getSchools();

  @override
  Future<School?> getById(String id) => getSchool(id);

  @override
  Future<void> update(String id, School item) => updateSchool(item);
}

class FirestoreSchoolRepository extends FirebaseRepository<School> implements SchoolRepository {
  FirestoreSchoolRepository({FirebaseFirestore? firestore}) 
      : super(collection: 'schools', firestore: firestore);
  
  @override
  Map<String, dynamic> toMap(School school) => school.toJson();
  
  @override
  School fromMap(Map<String, dynamic> map, String id) {
    final mapCopy = Map<String, dynamic>.from(map);
    if (mapCopy['id'] == null || mapCopy['id'] != id) {
      mapCopy['id'] = id;
    }
    return School.fromJson(mapCopy);
  }
  

  
  @override
  Future<List<School>> getSchools() => getAll();
  
  @override
  Future<School?> getSchool(String id) => getById(id);
  
  @override
  Future<String> addSchool(School school) async {
    return add(school);
  }
  
  @override
  Future<void> updateSchool(School school) async {
    await update(school.id, school);
  }
  
  @override
  Future<void> deleteSchool(String id) async {
    await delete(id);
  }
}