import 'package:flutter/material.dart';
import '../../entities/organization.dart';
import '../../entities/school.dart';
import '../../entities/pd_company.dart';

class AddOrganizationDialog extends StatelessWidget {
  final Function(Organization) onAdd;
  final String organizationType;

  const AddOrganizationDialog({
    super.key,
    required this.onAdd,
    required this.organizationType,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final usersController = TextEditingController();
    final coursesController = TextEditingController();
    final reportsController = TextEditingController();

    return AlertDialog(
      title: Text('Add New $organizationType'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name*',
                hintText: 'Enter ${organizationType.toLowerCase()} name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter ${organizationType.toLowerCase()} description',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usersController,
              decoration: const InputDecoration(
                labelText: 'Users*',
                hintText: 'Enter number of users',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: coursesController,
              decoration: const InputDecoration(
                labelText: 'Courses*',
                hintText: 'Enter number of courses',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reportsController,
              decoration: const InputDecoration(
                labelText: 'Reports*',
                hintText: 'Enter number of reports',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
            if (nameController.text.isEmpty || 
                usersController.text.isEmpty ||
                coursesController.text.isEmpty ||
                reportsController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all required fields')),
              );
              return;
            }

            final newOrg = organizationType == 'School'
                ? School(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text,
                    users: usersController.text,
                    courses: coursesController.text,
                    reports: reportsController.text,
                    lastUpdated: DateTime.now().toIso8601String().split('T')[0],
                  )
                : PDCompany(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text,
                    users: usersController.text,
                    courses: coursesController.text,
                    reports: reportsController.text,
                    lastUpdated: DateTime.now().toIso8601String().split('T')[0],
                  );

            onAdd(newOrg);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A80E5),
          ),
          child: const Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}