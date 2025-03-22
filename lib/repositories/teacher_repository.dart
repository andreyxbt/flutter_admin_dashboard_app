import 'dart:convert';
import '../entities/teacher.dart';
import '../services/shared_preferences_service.dart';

abstract class TeacherRepository {
  List<Teacher> getTeachers();
  Teacher? getTeacher(String id);
  void addTeacher(Teacher teacher);
  void updateTeacher(Teacher teacher);
  void deleteTeacher(String id);
}

class PersistentTeacherRepository implements TeacherRepository {
  static const String _storageKey = 'teachers';
  final SharedPreferencesService _prefsService;
  List<Teacher> _teachers = [];

  PersistentTeacherRepository(this._prefsService) {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr == null) {
      _teachers = [
        Teacher(
          userId: '1',
          orgId: '1',
          name: 'Jane Doe',
          email: 'jane.doe@school.com',
          organizationName: 'Example School',
          assignedCourses: ['Math 101', 'Math 102'],
          students: ['student1', 'student2', 'student3'],
        ),
        Teacher(
          userId: '2',
          orgId: '1',
          name: 'Robert Wilson',
          email: 'robert.w@school.com',
          organizationName: 'Example School',
          assignedCourses: ['Science 101', 'Science 102'],
          students: ['student4', 'student5', 'student6'],
        ),
      ];
      _saveTeachers();
    } else {
      final jsonList = jsonDecode(jsonStr) as List;
      _teachers = jsonList.map((json) => Teacher.fromJson(json)).toList();
    }
  }

  Future<void> _saveTeachers() async {
    final jsonList = _teachers.map((teacher) => teacher.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
  }

  @override
  List<Teacher> getTeachers() => List.from(_teachers);

  @override
  Teacher? getTeacher(String id) => 
      _teachers.firstWhere((teacher) => teacher.userId == id);

  @override
  void addTeacher(Teacher teacher) {
    _teachers.add(teacher);
    _saveTeachers();
  }

  @override
  void updateTeacher(Teacher teacher) {
    final index = _teachers.indexWhere((t) => t.userId == teacher.userId);
    if (index != -1) {
      _teachers[index] = teacher;
      _saveTeachers();
    }
  }

  @override
  void deleteTeacher(String id) {
    _teachers.removeWhere((teacher) => teacher.userId == id);
    _saveTeachers();
  }
}