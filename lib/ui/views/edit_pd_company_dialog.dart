import 'package:flutter/material.dart';
import '../../entities/pd_company.dart';

class EditPDCompanyDialog extends StatefulWidget {
  final PDCompany pdCompany;
  final Function(PDCompany) onSave;

  const EditPDCompanyDialog({
    super.key,
    required this.pdCompany,
    required this.onSave,
  });

  @override
  State<EditPDCompanyDialog> createState() => _EditPDCompanyDialogState();
}

class _EditPDCompanyDialogState extends State<EditPDCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _usersController;
  late final TextEditingController _coursesController;
  late final TextEditingController _reportsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pdCompany.name);
    _descriptionController = TextEditingController(text: widget.pdCompany.description);
    _usersController = TextEditingController(text: widget.pdCompany.users);
    _coursesController = TextEditingController(text: widget.pdCompany.courses);
    _reportsController = TextEditingController(text: widget.pdCompany.reports);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _usersController.dispose();
    _coursesController.dispose();
    _reportsController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final updatedCompany = PDCompany(
        id: widget.pdCompany.id,
        name: _nameController.text,
        description: _descriptionController.text,
        users: _usersController.text,
        courses: _coursesController.text,
        reports: _reportsController.text,
        lastUpdated: DateTime.now().toIso8601String(),
        userIds: widget.pdCompany.userIds,
      );
      widget.onSave(updatedCompany);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit PD Company'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _usersController,
                decoration: const InputDecoration(labelText: 'Number of Users'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of users';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _coursesController,
                decoration: const InputDecoration(labelText: 'Number of Courses'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of courses';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reportsController,
                decoration: const InputDecoration(labelText: 'Number of Reports'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of reports';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}