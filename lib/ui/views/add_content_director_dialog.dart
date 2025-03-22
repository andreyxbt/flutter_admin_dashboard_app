import 'package:flutter/material.dart';
import '../../entities/content_director.dart';
import '../../entities/pd_company.dart';

class AddContentDirectorDialog extends StatefulWidget {
  final Function(ContentDirector) onAdd;
  final List<PDCompany> availableCompanies;

  const AddContentDirectorDialog({
    super.key,
    required this.onAdd,
    required this.availableCompanies,
  });

  @override
  State<AddContentDirectorDialog> createState() => _AddContentDirectorDialogState();
}

class _AddContentDirectorDialogState extends State<AddContentDirectorDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  PDCompany? _selectedCompany;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Content Director'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name*',
                hintText: 'Enter content director name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email*',
                hintText: 'Enter content director email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PDCompany?>(
              value: _selectedCompany,
              decoration: const InputDecoration(
                labelText: 'PD Company (Optional)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<PDCompany?>(
                  value: null,
                  child: Text('No Company'),
                ),
                ...widget.availableCompanies.map((company) {
                  return DropdownMenuItem<PDCompany>(
                    value: company,
                    child: Text(company.name),
                  );
                }).toList(),
              ],
              onChanged: (PDCompany? value) {
                setState(() {
                  _selectedCompany = value;
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

            final contentDirector = ContentDirector(
              userId: DateTime.now().millisecondsSinceEpoch.toString(),
              orgId: _selectedCompany?.id,
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _selectedCompany?.name,
            );

            widget.onAdd(contentDirector);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}