import 'package:flutter/material.dart';
import '../entities/pd_company.dart';

class AddPDCompanyDialog extends StatelessWidget {
  final Function(PDCompany) onAdd;

  const AddPDCompanyDialog({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final usersController = TextEditingController();
    final coursesController = TextEditingController();
    final reportsController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New PD Company'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name*',
                hintText: 'Enter company name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter company description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usersController,
              decoration: const InputDecoration(
                labelText: 'Users*',
                hintText: 'Enter number of users',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: coursesController,
              decoration: const InputDecoration(
                labelText: 'Courses*',
                hintText: 'Enter number of courses',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reportsController,
              decoration: const InputDecoration(
                labelText: 'Reports*',
                hintText: 'Enter number of reports',
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
        TextButton(
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

            final newCompany = PDCompany(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: nameController.text,
              description: descriptionController.text,
              users: usersController.text,
              courses: coursesController.text,
              reports: reportsController.text,
              lastUpdated: DateTime.now().toIso8601String().split('T')[0],
            );

            onAdd(newCompany);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}