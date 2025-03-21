import 'package:flutter/material.dart';
import '../entities/user.dart';
import '../entities/school.dart';
import '../repositories/user_repository.dart';

class UserModel extends ChangeNotifier {
  final UserRepository _repository;
  final List<School> _schools;
  final Future<void> Function(School) _updateSchool;
  List<User> _users = [];
  List<User> _filteredUsers = [];
  String _searchQuery = '';

  UserModel(this._repository, this._schools, this._updateSchool) {
    _loadUsers();
  }

  List<User> get users => _filteredUsers;

  void _loadUsers() {
    _users = _repository.getUsers();
    print("Loaded users: $_users");
    _filteredUsers = List.from(_users);
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _filteredUsers = _users.where((user) =>
      user.name.toLowerCase().contains(_searchQuery) ||
      user.email.toLowerCase().contains(_searchQuery) ||
      (user.organizationName?.toLowerCase() ?? '').contains(_searchQuery)
    ).toList();
    notifyListeners();
  }

  void addUser(User user) {
    _repository.addUser(user);
    if (user.orgId != null) {
      try {
        final school = _schools.firstWhere(
          (school) => school.id == user.orgId,
        );
        final updatedSchool = school.copyWith();
        updatedSchool.addUser(user.userId);
        _updateSchool(updatedSchool);
      } catch (_) {
        // School not found, continue with user addition
      }
    }
    _loadUsers();
  }

  void updateUser(User user) {
    final oldUser = _users.firstWhere((u) => u.userId == user.userId);

    // Remove user from old school if there was one
    if (oldUser.orgId != null) {
      try {
        final oldSchool = _schools.firstWhere(
          (school) => school.id == oldUser.orgId,
        );
        final updatedOldSchool = oldSchool.copyWith();
        updatedOldSchool.removeUser(oldUser.userId);
        _updateSchool(updatedOldSchool);
      } catch (_) {
        // Old school not found, continue
      }
    }

    // Add user to new school if there is one
    if (user.orgId != null) {
      try {
        final newSchool = _schools.firstWhere(
          (school) => school.id == user.orgId,
        );
        final updatedNewSchool = newSchool.copyWith();
        updatedNewSchool.addUser(user.userId);
        _updateSchool(updatedNewSchool);
      } catch (_) {
        // New school not found, continue
      }
    }

    _repository.updateUser(user);
    _loadUsers();
  }

  void deleteUser(String id) {
    final user = _users.firstWhere((u) => u.userId == id);
    if (user.orgId != null) {
      try {
        final school = _schools.firstWhere(
          (school) => school.id == user.orgId,
        );
        final updatedSchool = school.copyWith();
        updatedSchool.removeUser(user.userId);
        _updateSchool(updatedSchool);
      } catch (_) {
        // School not found, continue with user deletion
      }
    }
    _repository.deleteUser(id);
    _loadUsers();
  }
}