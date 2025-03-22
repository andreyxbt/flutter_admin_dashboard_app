import 'package:flutter/material.dart';
import '../../entities/teacher.dart';
import '../../entities/school.dart';

class AddTeacherDialog extends StatefulWidget {
  final Function(Teacher) onAdd;
  final List<School> availableSchools;

  const AddTeacherDialog({
    super.key,
    required this.onAdd,
    required this.availableSchools,
  });

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  School? _selectedSchool;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Teacher'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name*',
                hintText: 'Enter teacher name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email*',
                hintText: 'Enter teacher email',
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

            final teacher = Teacher(
              userId: DateTime.now().millisecondsSinceEpoch.toString(),
              orgId: _selectedSchool?.id,
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _selectedSchool?.name,
            );

            widget.onAdd(teacher);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}