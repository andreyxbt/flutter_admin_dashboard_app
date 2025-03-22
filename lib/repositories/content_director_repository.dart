import 'dart:convert';
import '../entities/content_director.dart';
import '../services/shared_preferences_service.dart';

abstract class ContentDirectorRepository {
  Future<List<ContentDirector>> getContentDirectors();
  Future<ContentDirector?> getContentDirector(String id);
  Future<void> addContentDirector(ContentDirector contentDirector);
  Future<void> updateContentDirector(ContentDirector contentDirector);
  Future<void> deleteContentDirector(String id);
}

class PersistentContentDirectorRepository implements ContentDirectorRepository {
  static const String _storageKey = 'content_directors';
  final SharedPreferencesService _prefsService;
  List<ContentDirector> _contentDirectors = [];
  bool _initialized = false;

  PersistentContentDirectorRepository(this._prefsService);

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _initializeDefaultData();
      _initialized = true;
    }
  }

  Future<void> _initializeDefaultData() async {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr == null) {
      _contentDirectors = [
        ContentDirector(
          userId: '1',
          orgId: '1',
          name: 'John Smith',
          email: 'john.smith@pdcompany.com',
          organizationName: 'Example PD Company',
          assignedCourses: ['Math 101', 'Science 101'],
        ),
        ContentDirector(
          userId: '2',
          orgId: '2',
          name: 'Sarah Johnson',
          email: 'sarah.j@pdcompany.com',
          organizationName: 'Another PD Company',
          assignedCourses: ['History 101', 'English 101'],
        ),
      ];
      await _saveContentDirectors();
    } else {
      final jsonList = jsonDecode(jsonStr) as List;
      _contentDirectors = jsonList.map((json) => ContentDirector.fromJson(json)).toList();
    }
  }

  Future<void> _saveContentDirectors() async {
    final jsonList = _contentDirectors.map((director) => director.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
  }

  @override
  Future<List<ContentDirector>> getContentDirectors() async {
    await _ensureInitialized();
    return List.from(_contentDirectors);
  }

  @override
  Future<ContentDirector?> getContentDirector(String id) async {
    await _ensureInitialized();
    try {
      return _contentDirectors.firstWhere((director) => director.userId == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addContentDirector(ContentDirector contentDirector) async {
    await _ensureInitialized();
    _contentDirectors.add(contentDirector);
    await _saveContentDirectors();
  }

  @override
  Future<void> updateContentDirector(ContentDirector contentDirector) async {
    await _ensureInitialized();
    final index = _contentDirectors.indexWhere((d) => d.userId == contentDirector.userId);
    if (index != -1) {
      _contentDirectors[index] = contentDirector;
      await _saveContentDirectors();
    }
  }

  @override
  Future<void> deleteContentDirector(String id) async {
    await _ensureInitialized();
    _contentDirectors.removeWhere((director) => director.userId == id);
    await _saveContentDirectors();
  }
}