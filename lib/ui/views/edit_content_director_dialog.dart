import 'package:flutter/material.dart';
import '../../entities/content_director.dart';
import '../../entities/pd_company.dart';

class EditContentDirectorDialog extends StatefulWidget {
  final ContentDirector contentDirector;
  final Function(ContentDirector) onSave;
  final List<PDCompany> availableCompanies;

  const EditContentDirectorDialog({
    super.key,
    required this.contentDirector,
    required this.onSave,
    required this.availableCompanies,
  });

  @override
  State<EditContentDirectorDialog> createState() => _EditContentDirectorDialogState();
}

class _EditContentDirectorDialogState extends State<EditContentDirectorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  PDCompany? _selectedCompany;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contentDirector.name);
    _emailController = TextEditingController(text: widget.contentDirector.email);

    // Initialize selected company if content director has one
    if (widget.contentDirector.orgId != null) {
      try {
        _selectedCompany = widget.availableCompanies.firstWhere(
          (company) => company.id == widget.contentDirector.orgId,
        );
      } catch (_) {
        // Company not found, leave as null
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
      title: const Text('Edit Content Director'),
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

            final updatedContentDirector = ContentDirector(
              userId: widget.contentDirector.userId,
              orgId: _selectedCompany?.id,
              name: _nameController.text,
              email: _emailController.text,
              organizationName: _selectedCompany?.name,
              assignedCourses: widget.contentDirector.assignedCourses,
            );

            widget.onSave(updatedContentDirector);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}