import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pd_company_model.dart';
import '../../repositories/pd_company_repository.dart';
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
    return ChangeNotifierProvider(
      create: (_) => PDCompanyModel(InMemoryPDCompanyRepository()),
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
                      // TODO: Implement add PD company dialog
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
}