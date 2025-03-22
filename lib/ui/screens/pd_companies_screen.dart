import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/pd_companies_table_widget.dart';
import '../widgets/search_bar_component.dart';
import '../../models/pd_company_model.dart';
import '../../entities/pd_company.dart';
import '../views/add_pd_company_dialog.dart';
import '../views/edit_pd_company_dialog.dart';
import '../../repositories/pd_company_repository.dart';
import '../../services/shared_preferences_service.dart';

class PDCompaniesScreen extends StatefulWidget {
  const PDCompaniesScreen({super.key});

  @override
  State<PDCompaniesScreen> createState() => PDCompaniesScreenState();
}

class PDCompaniesScreenState extends State<PDCompaniesScreen> {
  late final PDCompanyRepository _pdCompanyRepository;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final prefsService = Provider.of<SharedPreferencesService>(context, listen: false);
      _pdCompanyRepository = PersistentPDCompanyRepository(prefsService);
      _initializeData();
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider(
      create: (_) => PDCompanyModel(_pdCompanyRepository),
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
                child: PDCompaniesTableWidget(
                  pdCompanies: model.pdCompanies,
                  onDelete: (id) => model.deletePDCompany(id),
                  onEdit: (company) => _showEditDialog(context, model, company),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, PDCompanyModel model) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AddPDCompanyDialog(
        onAdd: (company) => model.addPDCompany(company),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, PDCompanyModel model, PDCompany company) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => EditPDCompanyDialog(
        pdCompany: company,
        onSave: (company) => model.updatePDCompany(company),
      ),
    );
  }
}