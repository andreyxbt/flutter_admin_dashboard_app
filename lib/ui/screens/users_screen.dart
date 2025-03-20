import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/users_table_widget.dart';
import '../widgets/search_bar_component.dart';
import '../../models/user_model.dart';

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
                // TODO: Add user management buttons here
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: UsersTableWidget(
                users: model.users,
              ),
            ),
          ],
        );
      },
    );
  }

  void onSearch(String query) {
    Provider.of<UserModel>(context, listen: false).search(query);
  }
}