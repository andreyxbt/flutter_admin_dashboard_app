import 'package:flutter/material.dart';
import '../../entities/user.dart';

class EditUserDialog extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _orgNameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _orgNameController = TextEditingController(text: widget.user.organizationName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _orgNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name*',
                hintText: 'Enter user name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email*',
                hintText: 'Enter user email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _orgNameController,
              decoration: const InputDecoration(
                labelText: 'Organization*',
                hintText: 'Enter organization name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isEmpty ||
                _emailController.text.isEmpty ||
                _orgNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all required fields')),
              );
              return;
            }

            final user = User(
              userId: widget.user.userId,
              orgId: widget.user.orgId,
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _orgNameController.text,
            );

            widget.onSave(user);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}