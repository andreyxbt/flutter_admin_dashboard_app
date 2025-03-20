import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/users_table_widget.dart';
import '../widgets/search_bar_component.dart';
import '../../models/user_model.dart';
import '../../entities/user.dart';  // Add this import
import '../views/add_user_dialog.dart';
import '../views/edit_user_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
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
    );
  }

  Future<void> _showAddDialog(BuildContext context, UserModel model) async {
    showDialog(
      context: context,
      builder: (context) => AddUserDialog(
        onAdd: (user) => model.addUser(user),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, UserModel model, User user) async {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(
        user: user,
        onSave: (user) => model.updateUser(user),
      ),
    );
  }

  void onSearch(String query) {
    Provider.of<UserModel>(context, listen: false).search(query);
  }
}