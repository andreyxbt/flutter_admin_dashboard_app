import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/users_table_widget.dart';
import '../../widgets/search_bar_component.dart';
import '../../models/user_model.dart';

class UsersTableComponent extends StatefulWidget {
  const UsersTableComponent({super.key});

  @override
  State<UsersTableComponent> createState() => UsersTableComponentState();
}

class UsersTableComponentState extends State<UsersTableComponent> {
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
                // TODO: Add user management buttons here similar to schools and PD companies
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