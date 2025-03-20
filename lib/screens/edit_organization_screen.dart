import 'package:flutter/material.dart';
import '../entities/organization.dart';

class EditOrganizationScreen extends StatefulWidget {
  final Organization organization;
  final Function(Organization) onSave;
  final String organizationType;

  const EditOrganizationScreen({
    super.key,
    required this.organization,
    required this.onSave,
    required this.organizationType,
  });

  @override
  State<EditOrganizationScreen> createState() => _EditOrganizationScreenState();
}

class _EditOrganizationScreenState extends State<EditOrganizationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _usersController;
  late TextEditingController _coursesController;
  late TextEditingController _reportsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.organization.name);
    _descriptionController = TextEditingController(text: widget.organization.description);
    _usersController = TextEditingController(text: widget.organization.users);
    _coursesController = TextEditingController(text: widget.organization.courses);
    _reportsController = TextEditingController(text: widget.organization.reports);
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit ${widget.organizationType}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D141C),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${widget.organizationType} Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usersController,
              decoration: const InputDecoration(
                labelText: 'Users',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _coursesController,
              decoration: const InputDecoration(
                labelText: 'Courses',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reportsController,
              decoration: const InputDecoration(
                labelText: 'Reports',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _usersController.text.isEmpty ||
                        _coursesController.text.isEmpty ||
                        _reportsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all required fields')),
                      );
                      return;
                    }
                    
                    final updatedOrg = widget.organization.copyWith(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      users: _usersController.text,
                      courses: _coursesController.text,
                      reports: _reportsController.text,
                      lastUpdated: DateTime.now().toIso8601String().split('T')[0],
                    );
                    widget.onSave(updatedOrg);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A80E5),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}