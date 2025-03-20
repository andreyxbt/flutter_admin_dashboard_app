import 'package:flutter/material.dart';
import '../widgets/search_widget.dart';
import '../widgets/users_table_component.dart';

class UsersScreen extends StatefulWidget {
  final List<User> users;
  
  const UsersScreen({
    super.key,
    required this.users,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _tableKey = GlobalKey<UsersTableComponentState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(
          hintText: 'Search users',
          onSearch: (query) => _tableKey.currentState?.filterUsers(query),
        ),
        Expanded(
          child: UsersTableComponent(
            key: _tableKey,
            users: widget.users,
          ),
        ),
      ],
    );
  }
}