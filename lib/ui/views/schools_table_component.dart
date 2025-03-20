import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/organizations_table_component.dart';
import '../../widgets/search_bar_component.dart';
import '../../entities/school.dart';
import '../../models/school_model.dart';
import '../../widgets/add_school_dialog.dart';
import '../../screens/edit_organization_screen.dart';

class SchoolsTableComponent extends StatefulWidget {
  const SchoolsTableComponent({super.key});

  @override
  State<SchoolsTableComponent> createState() => SchoolsTableComponentState();
}

class SchoolsTableComponentState extends State<SchoolsTableComponent> {
  final _tableKey = GlobalKey<OrganizationsTableComponentState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchBarComponent(
                    key: const ValueKey('search_schools'),
                    hintText: 'Search schools',
                    onSearch: onSearch,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(context, model),
                  icon: const Icon(Icons.add),
                  label: const Text('Add School'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: OrganizationsTableComponent(
                key: _tableKey,
                organizations: model.schools,
                onDelete: (id) => model.deleteSchool(id),
                onEdit: (org) => _showEditDialog(context, model, org as School),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialog(BuildContext context, SchoolModel model) async {
    showDialog(
      context: context,
      builder: (context) => AddSchoolDialog(
        onAdd: model.addSchool,
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, SchoolModel model, School school) async {
    showDialog(
      context: context,
      builder: (context) => EditOrganizationScreen(
        organization: school,
        onSave: (org) => model.updateSchool(org as School),
        organizationType: 'School',
      ),
    );
  }

  void onSearch(String query) {
    Provider.of<SchoolModel>(context, listen: false).search(query);
  }
}
