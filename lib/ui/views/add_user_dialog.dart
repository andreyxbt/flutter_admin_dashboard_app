import 'package:flutter/material.dart';
import '../../entities/user.dart';

class AddUserDialog extends StatefulWidget {
  final Function(User) onAdd;

  const AddUserDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _orgNameController = TextEditingController();

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
      title: const Text('Add User'),
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
              userId: DateTime.now().millisecondsSinceEpoch.toString(),
              orgId: '1', // You might want to make this dynamic based on selected organization
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _orgNameController.text,
            );

            widget.onAdd(user);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}