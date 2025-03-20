import 'package:flutter/material.dart';
import '../entities/user.dart';

class UsersTableWidget extends StatelessWidget {
  final List<User> users;

  const UsersTableWidget({
    super.key,
    required this.users,
  });

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
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _buildRow(users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}