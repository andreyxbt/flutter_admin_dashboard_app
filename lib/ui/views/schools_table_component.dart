import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/organizations_table_component.dart';
import '../../entities/school.dart';
import '../../models/school_model.dart';
import 'edit_organization_dialog.dart';

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
        return OrganizationsTableComponent(
          key: _tableKey,
          organizations: model.schools,
          onDelete: (id) => model.deleteSchool(id),
          onEdit: (org) => _showEditDialog(context, model, org as School),
        );
      },
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
}
