import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/users_table_widget.dart';
import '../widgets/search_bar_component.dart';
import '../../models/user_model.dart';
import '../../entities/user.dart';
import '../../entities/school.dart';
import '../views/add_user_dialog.dart';
import '../views/edit_user_dialog.dart';
import '../../repositories/school_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/shared_preferences_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  late final SchoolRepository _schoolRepository;
  late final UserRepository _userRepository;
  List<School> _schools = [];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final prefsService = Provider.of<SharedPreferencesService>(context, listen: false);
      _schoolRepository = PersistentSchoolRepository(prefsService);
      _userRepository = PersistentUserRepository(prefsService);
      _loadSchools();
    }
  }

  Future<void> _loadSchools() async {
    final schools = await _schoolRepository.getSchools();
    setState(() {
      _schools = schools;
    });
  }

  Future<void> _updateSchool(School school) async {
    await _schoolRepository.updateSchool(school);
    await _loadSchools();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserModel(
        _userRepository,
        _schools,
        _updateSchool,
      ),
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBarComponent(
                      key: const ValueKey('search_users'),
                      hintText: 'Search users',
                      onSearch: onSearch,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context, model),
                    icon: const Icon(Icons.add),
                    label: const Text('Add User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: UsersTableWidget(
                  users: model.users,
                  onDelete: (id) => model.deleteUser(id),
                  onEdit: (user) => _showEditDialog(context, model, user),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, UserModel model) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AddUserDialog(
        onAdd: (user) => model.addUser(user),
        availableSchools: _schools,
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, UserModel model, User user) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => EditUserDialog(
        user: user,
        onSave: (user) => model.updateUser(user),
        availableSchools: _schools,
      ),
    );
  }

  void onSearch(String query) {
    Provider.of<UserModel>(context, listen: false).search(query);
  }
}