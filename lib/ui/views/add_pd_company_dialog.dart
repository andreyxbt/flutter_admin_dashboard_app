import 'package:flutter/material.dart';
import '../../entities/pd_company.dart';

class AddPDCompanyDialog extends StatefulWidget {
  final Function(PDCompany) onAdd;

  const AddPDCompanyDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddPDCompanyDialog> createState() => _AddPDCompanyDialogState();
}

class _AddPDCompanyDialogState extends State<AddPDCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _usersController = TextEditingController();
  final _coursesController = TextEditingController();
  final _reportsController = TextEditingController();

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
      final company = PDCompany(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        users: _usersController.text,
        courses: _coursesController.text,
        reports: _reportsController.text,
        lastUpdated: DateTime.now().toIso8601String(),
      );
      widget.onAdd(company);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add PD Company'),
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
          child: const Text('Add'),
        ),
      ],
    );
  }
}