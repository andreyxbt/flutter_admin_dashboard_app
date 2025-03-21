import 'package:flutter/foundation.dart';
import '../entities/school.dart';
import '../repositories/school_repository.dart';

class SchoolModel extends ChangeNotifier {
  final SchoolRepository _repository;
  List<School> _schools = [];
  String _searchQuery = '';

  SchoolModel(this._repository) {
    _loadSchools();
  }

  List<School> get schools => _searchQuery.isEmpty 
    ? _schools 
    : _schools.where((school) => 
        school.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (school.description).toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();

  Future<void> _loadSchools() async {
    _schools = await _repository.getSchools();
    notifyListeners();
  }

  Future<void> addSchool(School school) async {
    await _repository.addSchool(school);
    await _loadSchools();
  }

  Future<void> updateSchool(School school) async {
    // Update the users count to reflect actual number of associated users
    final updatedSchool = school.copyWith(
      users: school.userCount.toString(),
    );
    await _repository.updateSchool(updatedSchool);
    await _loadSchools();
  }

  Future<void> deleteSchool(String id) async {
    await _repository.deleteSchool(id);
    await _loadSchools();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}