import 'package:flutter/material.dart';
import '../../entities/user.dart';
import '../../entities/school.dart';

class EditUserDialog extends StatefulWidget {
  final User user;
  final Function(User) onSave;
  final List<School> availableSchools;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.onSave,
    required this.availableSchools,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  School? _selectedSchool;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);

    // Initialize selected school if user has one
    if (widget.user.orgId != null) {
      try {
        _selectedSchool = widget.availableSchools.firstWhere(
          (school) => school.id == widget.user.orgId,
        );
      } catch (_) {
        // School not found, leave as null
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
            DropdownButtonFormField<School?>(
              value: _selectedSchool,
              decoration: const InputDecoration(
                labelText: 'School (Optional)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<School?>(
                  value: null,
                  child: Text('No School'),
                ),
                ...widget.availableSchools.map((school) {
                  return DropdownMenuItem<School>(
                    value: school,
                    child: Text(school.name),
                  );
                }).toList(),
              ],
              onChanged: (School? value) {
                setState(() {
                  _selectedSchool = value;
                });
              },
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
            if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all required fields')),
              );
              return;
            }

            final updatedUser = User(
              userId: widget.user.userId,
              orgId: _selectedSchool?.id,
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _selectedSchool?.name,
            );

            widget.onSave(updatedUser);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}