import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/organizations_table_widget.dart';
import '../widgets/search_bar_component.dart';
import '../../entities/pd_company.dart';
import '../../models/pd_company_model.dart';
import '../views/edit_organization_dialog.dart';
import '../views/add_organization_dialog.dart';

class PDCompaniesTableComponent extends StatefulWidget {
  const PDCompaniesTableComponent({super.key});

  @override
  State<PDCompaniesTableComponent> createState() => _PDCompaniesTableComponentState();
}

class _PDCompaniesTableComponentState extends State<PDCompaniesTableComponent> {
  final _tableKey = GlobalKey<OrganizationsTableWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PDCompanyModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchBarComponent(
                    key: const ValueKey('search_pd_companies'),
                    hintText: 'Search PD companies',
                    onSearch: onSearch,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(context, model),
                  icon: const Icon(Icons.add),
                  label: const Text('Add PD Company'),
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
              child: OrganizationsTableWidget(
                key: _tableKey,
                organizations: model.companies,
                onDelete: (id) => model.deleteCompany(id),
                onEdit: (org) => _showEditDialog(context, model, org as PDCompany),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialog(BuildContext context, PDCompanyModel model) async {
    showDialog(
      context: context,
      builder: (context) => AddOrganizationDialog(
        onAdd: (org) => model.addCompany(org as PDCompany),
        organizationType: 'PD Company',
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, PDCompanyModel model, PDCompany company) async {
    showDialog(
      context: context,
      builder: (context) => EditOrganizationScreen(
        organization: company,
        onSave: (org) => model.updateCompany(org as PDCompany),
        organizationType: 'PD Company',
      ),
    );
  }

  void onSearch(String query) {
    Provider.of<PDCompanyModel>(context, listen: false).search(query);
  }
}