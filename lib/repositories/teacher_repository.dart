import 'dart:convert';
import '../entities/teacher.dart';
import '../services/shared_preferences_service.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

abstract class TeacherRepository implements BaseRepository<Teacher> {
  Future<List<Teacher>> getTeachers();
  Future<Teacher?> getTeacher(String id);
  Future<void> addTeacher(Teacher teacher);
  Future<void> updateTeacher(Teacher teacher);
  Future<void> deleteTeacher(String id);
  Future<List<Teacher>> getTeachersByOrganization(String orgId);
  Future<List<Teacher>> searchTeachers(String query);
}

class PersistentTeacherRepository implements TeacherRepository {
  static const String _storageKey = 'teachers';
  final SharedPreferencesService _prefsService;
  final FirestoreTeacherRepository _firebaseRepo;
  List<Teacher> _cachedTeachers = [];
  bool _initialized = false;

  PersistentTeacherRepository(this._prefsService, this._firebaseRepo);

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
      _cachedTeachers = jsonList.map((json) => Teacher.fromJson(json)).toList();
    }
  }

  Future<void> _saveToCache(List<Teacher> teachers) async {
    final jsonList = teachers.map((teacher) => teacher.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
    _cachedTeachers = teachers;
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    try {
      final teachers = await _firebaseRepo.getAll();
      await _saveToCache(teachers);
      return teachers;
    } catch (e) {
      await _ensureInitialized();
      return List.from(_cachedTeachers);
    }
  }

  @override
  Future<Teacher?> getTeacher(String id) async {
    try {
      final teacher = await _firebaseRepo.getById(id);
      if (teacher != null) {
        await _ensureInitialized();
        final index = _cachedTeachers.indexWhere((t) => t.userId == id);
        if (index >= 0) {
          _cachedTeachers[index] = teacher;
        } else {
          _cachedTeachers.add(teacher);
        }
        await _saveToCache(_cachedTeachers);
      }
      return teacher;
    } catch (e) {
      await _ensureInitialized();
      return _cachedTeachers.firstWhereOrNull((t) => t.userId == id);
    }
  }

  @override
  Future<String> addTeacher(Teacher teacher) async {
    final id = await _firebaseRepo.add(teacher);
    teacher = teacher.copyWith(userId: id);
    await _ensureInitialized();
    _cachedTeachers.add(teacher);
    await _saveToCache(_cachedTeachers);
    return id;
  }

  @override
  Future<void> updateTeacher(Teacher teacher) async {
    await _firebaseRepo.update(teacher.userId, teacher);
    await _ensureInitialized();
    final index = _cachedTeachers.indexWhere((t) => t.userId == teacher.userId);
    if (index >= 0) {
      _cachedTeachers[index] = teacher;
      await _saveToCache(_cachedTeachers);
    }
  }

  @override
  Future<void> deleteTeacher(String id) async {
    await _firebaseRepo.delete(id);
    await _ensureInitialized();
    _cachedTeachers.removeWhere((t) => t.userId == id);
    await _saveToCache(_cachedTeachers);
  }

  @override
  Future<List<Teacher>> getTeachersByOrganization(String orgId) async {
    try {
      return await _firebaseRepo.getTeachersByOrganization(orgId);
    } catch (e) {
      await _ensureInitialized();
      return _cachedTeachers.where((teacher) => teacher.orgId == orgId).toList();
    }
  }

  @override
  Future<List<Teacher>> searchTeachers(String query) async {
    try {
      return await _firebaseRepo.searchTeachers(query);
    } catch (e) {
      await _ensureInitialized();
      query = query.toLowerCase();
      return _cachedTeachers.where((teacher) =>
        teacher.name.toLowerCase().contains(query) ||
        teacher.email.toLowerCase().contains(query)
      ).toList();
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefsService.remove(_storageKey);
    _cachedTeachers.clear();
    _initialized = false;
  }

  @override
  Future<List<Teacher>> refreshFromRemote() async {
    final teachers = await _firebaseRepo.getAll();
    await _saveToCache(teachers);
    return teachers;
  }

  @override
  Future<String> add(Teacher item) => addTeacher(item);

  @override
  Future<void> delete(String id) => deleteTeacher(id);

  @override
  Future<List<Teacher>> getAll() => getTeachers();

  @override
  Future<Teacher?> getById(String id) => getTeacher(id);

  @override
  Future<void> update(String id, Teacher item) => updateTeacher(item);
}

class FirestoreTeacherRepository extends FirebaseRepository<Teacher> implements TeacherRepository {
  FirestoreTeacherRepository({FirebaseFirestore? firestore}) 
      : super(collection: 'teachers', firestore: firestore);
  
  @override
  Map<String, dynamic> toMap(Teacher teacher) {
    final map = teacher.toJson();
    map['id'] = teacher.userId;
    return map;
  }
  
  @override
  Teacher fromMap(Map<String, dynamic> map, String id) {
    final mapCopy = Map<String, dynamic>.from(map);
    if (mapCopy['userId'] == null || mapCopy['userId'] != id) {
      mapCopy['userId'] = id;
    }
    return Teacher.fromJson(mapCopy);
  }
  
  Future<List<Teacher>> getTeachersByOrganization(String orgId) async {
    final snapshot = await collection
        .where('orgId', isEqualTo: orgId)
        .get();
    
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }
  
  Future<List<Teacher>> searchTeachers(String query) async {
    query = query.toLowerCase();
    final allTeachers = await getAll();
    return allTeachers.where((teacher) =>
      teacher.name.toLowerCase().contains(query) ||
      teacher.email.toLowerCase().contains(query)
    ).toList();
  }
  
  @override
  Future<List<Teacher>> getTeachers() => getAll();
  
  @override
  Future<Teacher?> getTeacher(String id) => getById(id);
  
  @override
  Future<void> addTeacher(Teacher teacher) async {
    await add(teacher);
  }
  
  @override
  Future<void> updateTeacher(Teacher teacher) async {
    await update(teacher.userId, teacher);
  }
  
  @override
  Future<void> deleteTeacher(String id) async {
    await delete(id);
  }
}