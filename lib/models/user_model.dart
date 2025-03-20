import 'package:flutter/material.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UserModel extends ChangeNotifier {
  final UserRepository _repository;
  List<User> _users = [];
  List<User> _filteredUsers = [];
  String _searchQuery = '';

  UserModel(this._repository) {
    _loadUsers();
  }

  List<User> get users => _filteredUsers;

  void _loadUsers() {
    _users = _repository.getUsers();
    _filteredUsers = List.from(_users);
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _filteredUsers = _users.where((user) =>
      user.name.toLowerCase().contains(_searchQuery) ||
      user.email.toLowerCase().contains(_searchQuery) ||
      user.organizationName.toLowerCase().contains(_searchQuery)
    ).toList();
    notifyListeners();
  }

  void addUser(User user) {
    _repository.addUser(user);
    _loadUsers();
  }

  void updateUser(User user) {
    _repository.updateUser(user);
    _loadUsers();
  }

  void deleteUser(String id) {
    _repository.deleteUser(id);
    _loadUsers();
  }
}