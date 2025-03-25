import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/entities/school.dart';
import 'package:flutter_admin_dashboard_app/ui/views/add_organization_dialog.dart';
import 'package:provider/provider.dart';
import '../../models/school_model.dart';
import '../../repositories/school_repository.dart';
import '../../repositories/repository_provider.dart';
import '../widgets/search_bar_component.dart';
import '../views/schools_table_component.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  late final SchoolRepository _schoolRepository;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final repositoryProvider = Provider.of<RepositoryProvider>(context, listen: false);
      _schoolRepository = repositoryProvider.schoolRepository;
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
      create: (_) => SchoolModel(_schoolRepository),
      child: Consumer<SchoolModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBarComponent(
                      key: const ValueKey('search_schools'),
                      hintText: 'Search schools',
                      onSearch: (query) => model.search(query),
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
              const Expanded(
                child: SchoolsTableComponent(),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, SchoolModel model) async {
    showDialog(
      context: context,
      builder: (context) => AddOrganizationDialog(
        onAdd: (org) => model.addSchool(org as School),
        organizationType: 'School',
      ),
    );
  }
}