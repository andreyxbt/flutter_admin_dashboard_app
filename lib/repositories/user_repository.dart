import '../entities/user.dart';

abstract class UserRepository {
  List<User> getUsers();
  User? getUser(String id);
  void addUser(User user);
  void updateUser(User user);
  void deleteUser(String id);
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
  List<User> getUsers() => List.from(_users);

  @override
  User? getUser(String id) => _users.firstWhere((user) => user.userId == id);

  @override
  void addUser(User user) => _users.add(user);

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