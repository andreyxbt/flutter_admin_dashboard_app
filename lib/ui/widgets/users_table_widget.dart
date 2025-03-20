import 'package:flutter/material.dart';
import '../../entities/user.dart';

class UsersTableWidget extends StatefulWidget {
  final List<User> users;
  final Function(String)? onDelete;
  final Function(User)? onEdit;

  const UsersTableWidget({
    super.key,
    required this.users,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<UsersTableWidget> createState() => UsersTableWidgetState();
}

class UsersTableWidgetState extends State<UsersTableWidget> {
  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0D141C),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, bool isName = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 72,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            if (isName) ...[
              CircleAvatar(
                backgroundColor: const Color(0xFFF0F4F9),
                child: Text(
                  text.isNotEmpty ? text[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Color(0xFF4F7396),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isName ? const Color(0xFF0D141C) : const Color(0xFF4F7396),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(User user) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && widget.onDelete != null) {
      widget.onDelete!(user.userId);
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF7FAFC),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Name', flex: 2),
          _buildHeaderCell('Email', flex: 2),
          _buildHeaderCell('Organization', flex: 2),
          _buildHeaderCell('Actions'),
        ],
      ),
    );
  }

  Widget _buildRow(User user) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E8EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildCell(user.name, flex: 2, isName: true),
          _buildCell(user.email, flex: 2),
          _buildCell(user.organizationName, flex: 2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF4F7396)),
                    onPressed: widget.onEdit != null ? () => widget.onEdit!(user) : null,
                    tooltip: 'Edit user',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFF4F7396)),
                    onPressed: widget.onDelete != null ? () => _showDeleteConfirmation(user) : null,
                    tooltip: 'Delete user',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                return _buildRow(widget.users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}