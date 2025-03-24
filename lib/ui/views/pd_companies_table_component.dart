import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/organizations_table_component.dart';
import '../../entities/pd_company.dart';
import '../../models/pd_company_model.dart';
import 'edit_organization_dialog.dart';

class PDCompaniesTableComponent extends StatefulWidget {
  const PDCompaniesTableComponent({super.key});

  @override
  State<PDCompaniesTableComponent> createState() => PDCompaniesTableComponentState();
}

class PDCompaniesTableComponentState extends State<PDCompaniesTableComponent> {
  final _tableKey = GlobalKey<OrganizationsTableComponentState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PDCompanyModel>(
      builder: (context, model, child) {
        return OrganizationsTableComponent(
          key: _tableKey,
          organizations: model.companies,
          onDelete: (id) => model.deletePDCompany(id),
          onEdit: (org) => _showEditDialog(context, model, org as PDCompany),
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, PDCompanyModel model, PDCompany company) async {
    showDialog(
      context: context,
      builder: (context) => EditOrganizationScreen(
        organization: company,
        onSave: (org) => model.updatePDCompany(org as PDCompany),
        organizationType: 'PD Company',
      ),
    );
  }
}
