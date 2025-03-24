import 'dart:convert';
import '../entities/content_director.dart';
import '../services/shared_preferences_service.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

abstract class ContentDirectorRepository implements BaseRepository<ContentDirector> {
  Future<List<ContentDirector>> getContentDirectors();
  Future<ContentDirector?> getContentDirector(String id);
  Future<String> addContentDirector(ContentDirector contentDirector);
  Future<void> updateContentDirector(ContentDirector contentDirector);
  Future<void> deleteContentDirector(String id);
  Future<List<ContentDirector>> getDirectorsByOrganization(String orgId);
  Future<List<ContentDirector>> getDirectorsByAssignedCourse(String courseId);
}

class PersistentContentDirectorRepository implements ContentDirectorRepository {
  static const String _storageKey = 'content_directors';
  final SharedPreferencesService _prefsService;
  final FirestoreContentDirectorRepository _firebaseRepo;
  List<ContentDirector> _cachedDirectors = [];
  bool _initialized = false;

  PersistentContentDirectorRepository(this._prefsService, this._firebaseRepo);

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
      _cachedDirectors = jsonList.map((json) => ContentDirector.fromJson(json)).toList();
    }
  }

  Future<void> _saveToCache(List<ContentDirector> directors) async {
    final jsonList = directors.map((director) => director.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
    _cachedDirectors = directors;
  }

  @override
  Future<List<ContentDirector>> getContentDirectors() async {
    try {
      final directors = await _firebaseRepo.getAll();
      await _saveToCache(directors);
      return directors;
    } catch (e) {
      await _ensureInitialized();
      return List.from(_cachedDirectors);
    }
  }

  @override
  Future<ContentDirector?> getContentDirector(String id) async {
    try {
      final director = await _firebaseRepo.getById(id);
      if (director != null) {
        await _ensureInitialized();
        final index = _cachedDirectors.indexWhere((d) => d.userId == id);
        if (index >= 0) {
          _cachedDirectors[index] = director;
        } else {
          _cachedDirectors.add(director);
        }
        await _saveToCache(_cachedDirectors);
      }
      return director;
    } catch (e) {
      await _ensureInitialized();
      return _cachedDirectors.firstWhereOrNull((d) => d.userId == id);
    }
  }

  @override
  Future<String> addContentDirector(ContentDirector director) async {
    final id = await _firebaseRepo.add(director);
    director = director.copyWith(userId: id);
    await _ensureInitialized();
    _cachedDirectors.add(director);
    await _saveToCache(_cachedDirectors);
    return id;
  }

  @override
  Future<void> updateContentDirector(ContentDirector director) async {
    await _firebaseRepo.update(director.userId, director);
    await _ensureInitialized();
    final index = _cachedDirectors.indexWhere((d) => d.userId == director.userId);
    if (index >= 0) {
      _cachedDirectors[index] = director;
      await _saveToCache(_cachedDirectors);
    }
  }

  @override
  Future<void> deleteContentDirector(String id) async {
    await _firebaseRepo.delete(id);
    await _ensureInitialized();
    _cachedDirectors.removeWhere((d) => d.userId == id);
    await _saveToCache(_cachedDirectors);
  }

  @override
  Future<List<ContentDirector>> getDirectorsByOrganization(String orgId) async {
    try {
      return await _firebaseRepo.getDirectorsByOrganization(orgId);
    } catch (e) {
      await _ensureInitialized();
      return _cachedDirectors.where((director) => director.orgId == orgId).toList();
    }
  }

  @override
  Future<List<ContentDirector>> getDirectorsByAssignedCourse(String courseId) async {
    try {
      return await _firebaseRepo.getDirectorsByAssignedCourse(courseId);
    } catch (e) {
      await _ensureInitialized();
      return _cachedDirectors.where((director) => 
        director.assignedCourses.contains(courseId)
      ).toList();
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefsService.remove(_storageKey);
    _cachedDirectors.clear();
    _initialized = false;
  }

  @override
  Future<List<ContentDirector>> refreshFromRemote() async {
    final directors = await _firebaseRepo.getAll();
    await _saveToCache(directors);
    return directors;
  }

  @override
  Future<String> add(ContentDirector item) => addContentDirector(item);

  @override
  Future<void> delete(String id) => deleteContentDirector(id);

  @override
  Future<List<ContentDirector>> getAll() => getContentDirectors();

  @override
  Future<ContentDirector?> getById(String id) => getContentDirector(id);

  @override
  Future<void> update(String id, ContentDirector item) => updateContentDirector(item);
}

class FirestoreContentDirectorRepository extends FirebaseRepository<ContentDirector> implements ContentDirectorRepository {
  FirestoreContentDirectorRepository({FirebaseFirestore? firestore}) 
      : super(collection: 'content_directors', firestore: firestore);
  
  @override
  Map<String, dynamic> toMap(ContentDirector director) {
    final map = director.toJson();
    map['id'] = director.userId;
    return map;
  }
  
  @override
  ContentDirector fromMap(Map<String, dynamic> map, String id) {
    final mapCopy = Map<String, dynamic>.from(map);
    if (mapCopy['userId'] == null || mapCopy['userId'] != id) {
      mapCopy['userId'] = id;
    }
    return ContentDirector.fromJson(mapCopy);
  }
  
  Future<List<ContentDirector>> getDirectorsByOrganization(String orgId) async {
    final snapshot = await collection
        .where('orgId', isEqualTo: orgId)
        .get();
    
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }
  
  Future<List<ContentDirector>> getDirectorsByAssignedCourse(String courseId) async {
    final snapshot = await collection
        .where('assignedCourses', arrayContains: courseId)
        .get();
    
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }
  
  @override
  Future<List<ContentDirector>> getContentDirectors() => getAll();
  
  @override
  Future<ContentDirector?> getContentDirector(String id) => getById(id);
  
  @override
  Future<String> addContentDirector(ContentDirector director) async {
    return add(director);
  }
  
  @override
  Future<void> updateContentDirector(ContentDirector director) async {
    await update(director.userId, director);
  }
  
  @override
  Future<void> deleteContentDirector(String id) async {
    await delete(id);
  }
}