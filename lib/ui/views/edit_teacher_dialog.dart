import 'package:flutter/material.dart';
import '../../entities/teacher.dart';
import '../../entities/school.dart';

class EditTeacherDialog extends StatefulWidget {
  final Teacher teacher;
  final Function(Teacher) onSave;
  final List<School> availableSchools;

  const EditTeacherDialog({
    super.key,
    required this.teacher,
    required this.onSave,
    required this.availableSchools,
  });

  @override
  State<EditTeacherDialog> createState() => _EditTeacherDialogState();
}

class _EditTeacherDialogState extends State<EditTeacherDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  School? _selectedSchool;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _emailController = TextEditingController(text: widget.teacher.email);

    // Initialize selected school if teacher has one
    if (widget.teacher.orgId != null) {
      try {
        _selectedSchool = widget.availableSchools.firstWhere(
          (school) => school.id == widget.teacher.orgId,
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
      title: const Text('Edit Teacher'),
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

            final updatedTeacher = Teacher(
              userId: widget.teacher.userId,
              orgId: _selectedSchool?.id,
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _selectedSchool?.name,
              assignedCourses: widget.teacher.assignedCourses,
              students: widget.teacher.students,
            );

            widget.onSave(updatedTeacher);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}