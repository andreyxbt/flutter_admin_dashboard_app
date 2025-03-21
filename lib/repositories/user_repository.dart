import 'dart:convert';
import '../entities/user.dart';
import '../services/shared_preferences_service.dart';

abstract class UserRepository {
  List<User> getUsers();
  User? getUser(String id);
  void addUser(User user);
  void updateUser(User user);
  void deleteUser(String id);
}

class PersistentUserRepository implements UserRepository {
  static const String _storageKey = 'users';
  final SharedPreferencesService _prefsService;
  List<User> _users = [];

  PersistentUserRepository(this._prefsService) {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr == null) {
      _users = [
        User(
          userId: '1',
          orgId: '1',
          name: 'John Doe',
          email: 'john@example.com',
          organizationName: 'Example School',
        ),
        User(
          userId: '2',
          orgId: '1',
          name: 'Jane Smith',
          email: 'jane@example.com',
          organizationName: 'Example School',
        ),
      ];
      _saveUsers();
    } else {
      final jsonList = jsonDecode(jsonStr) as List;
      _users = jsonList.map((json) => User.fromJson(json)).toList();
    }
  }

  Future<void> _saveUsers() async {
    final jsonList = _users.map((user) => user.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
  }

  @override
  List<User> getUsers() => List.from(_users);

  @override
  User? getUser(String id) => _users.firstWhere((user) => user.userId == id);

  @override
  void addUser(User user) {
    _users.add(user);
    _saveUsers();
  }

  @override
  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.userId == user.userId);
    if (index != -1) {
      _users[index] = user;
      _saveUsers();
    }
  }

  @override
  void deleteUser(String id) {
    _users.removeWhere((user) => user.userId == id);
    _saveUsers();
  }
}

class InMemoryUserRepository implements UserRepository {
  final List<User> _users = [
    User(
      userId: '1',
      orgId: '1',
      name: 'John Doe',
      email: 'john@example.com',
      organizationName: 'Example School',
    ),
    User(
      userId: '2',
      orgId: '1',
      name: 'Jane Smith',
      email: 'jane@example.com',
      organizationName: 'Example School',
    ),
  ];

  @override
  List<User> getUsers() { 
    print("${this.hashCode} InMemoryUserRepository getUsers from userslist: ${_users.hashCode}");
    return List.from(_users); 
  }

  @override
  User? getUser(String id) => _users.firstWhere((user) => user.userId == id);

  @override
  void addUser(User user) { 
    print("${this.hashCode} InMemoryUserRepository addUser to userslist: ${_users.hashCode}");
    _users.add(user) ;
  }

  @override
  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.userId == user.userId);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  void deleteUser(String id) {
    _users.removeWhere((user) => user.userId == id);
  }
}