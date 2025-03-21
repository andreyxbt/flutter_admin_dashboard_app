import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/entities/pd_company.dart';
import 'package:flutter_admin_dashboard_app/ui/views/add_organization_dialog.dart';
import 'package:provider/provider.dart';
import '../../models/pd_company_model.dart';
import '../../repositories/pd_company_repository.dart';
import '../../services/shared_preferences_service.dart';
import '../widgets/search_bar_component.dart';
import '../views/pd_companies_table_component.dart';

class PDCompaniesScreen extends StatefulWidget {
  const PDCompaniesScreen({super.key});

  @override
  State<PDCompaniesScreen> createState() => _PDCompaniesScreenState();
}

class _PDCompaniesScreenState extends State<PDCompaniesScreen> {
  @override
  Widget build(BuildContext context) {
    final prefsService = Provider.of<SharedPreferencesService>(context);
    
    return ChangeNotifierProvider(
      create: (_) => PDCompanyModel(PersistentPDCompanyRepository(prefsService)),
      child: Consumer<PDCompanyModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBarComponent(
                      key: const ValueKey('search_pd_companies'),
                      hintText: 'Search PD companies',
                      onSearch: (query) => model.search(query),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddDialog(context, model);
                    },
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
              const Expanded(
                child: PDCompaniesTableComponent(),
              ),
            ],
          );
        },
      ),
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

}