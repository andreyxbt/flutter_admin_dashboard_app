import 'package:flutter/material.dart';
import '../entities/teacher.dart';
import '../entities/school.dart';
import '../repositories/teacher_repository.dart';

class TeacherModel extends ChangeNotifier {
  final TeacherRepository _repository;
  final List<School> _schools;
  final Future<void> Function(School) _updateSchool;
  List<Teacher> _teachers = [];
  List<Teacher> _filteredTeachers = [];
  String _searchQuery = '';
  bool _isLoading = false;

  TeacherModel(this._repository, this._schools, this._updateSchool) {
    _loadTeachers();
  }

  List<Teacher> get teachers => _filteredTeachers;
  bool get isLoading => _isLoading;

  Future<void> _loadTeachers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _teachers = await _repository.getTeachers();
      _filteredTeachers = List.from(_teachers);
    } catch (e) {
      debugPrint('Error loading teachers: $e');
      _teachers = [];
      _filteredTeachers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _filteredTeachers = _teachers.where((teacher) =>
      teacher.name.toLowerCase().contains(_searchQuery) ||
      teacher.email.toLowerCase().contains(_searchQuery) ||
      (teacher.organizationName?.toLowerCase() ?? '').contains(_searchQuery)
    ).toList();
    notifyListeners();
  }

  Future<void> addTeacher(Teacher teacher) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addTeacher(teacher);
      if (teacher.orgId != null) {
        try {
          final school = _schools.firstWhere(
            (school) => school.id == teacher.orgId,
          );
          final updatedSchool = school.copyWith();
          updatedSchool.addUser(teacher.userId);
          await _updateSchool(updatedSchool);
        } catch (_) {
          // School not found, continue with teacher addition
        }
      }
      await _loadTeachers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    _isLoading = true;
    notifyListeners();

    try {
      final oldTeacher = _teachers.firstWhere((t) => t.userId == teacher.userId);

      // Remove teacher from old school if there was one
      if (oldTeacher.orgId != null) {
        try {
          final oldSchool = _schools.firstWhere(
            (school) => school.id == oldTeacher.orgId,
          );
          final updatedOldSchool = oldSchool.copyWith();
          updatedOldSchool.removeUser(oldTeacher.userId);
          await _updateSchool(updatedOldSchool);
        } catch (_) {
          // Old school not found, continue
        }
      }

      // Add teacher to new school if there is one
      if (teacher.orgId != null) {
        try {
          final newSchool = _schools.firstWhere(
            (school) => school.id == teacher.orgId,
          );
          final updatedNewSchool = newSchool.copyWith();
          updatedNewSchool.addUser(teacher.userId);
          await _updateSchool(updatedNewSchool);
        } catch (_) {
          // New school not found, continue
        }
      }

      await _repository.updateTeacher(teacher);
      await _loadTeachers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTeacher(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final teacher = _teachers.firstWhere((t) => t.userId == id);
      if (teacher.orgId != null) {
        try {
          final school = _schools.firstWhere(
            (school) => school.id == teacher.orgId,
          );
          final updatedSchool = school.copyWith();
          updatedSchool.removeUser(teacher.userId);
          await _updateSchool(updatedSchool);
        } catch (_) {
          // School not found, continue with teacher deletion
        }
      }
      await _repository.deleteTeacher(id);
      await _loadTeachers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}