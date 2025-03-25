import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/content_directors_table_widget.dart';
import '../widgets/search_bar_component.dart';
import '../../models/content_director_model.dart';
import '../../entities/content_director.dart';
import '../../entities/pd_company.dart';
import '../views/add_content_director_dialog.dart';
import '../views/edit_content_director_dialog.dart';
import '../../repositories/pd_company_repository.dart';
import '../../repositories/content_director_repository.dart';
import '../../repositories/repository_provider.dart';

class ContentDirectorsScreen extends StatefulWidget {
  const ContentDirectorsScreen({super.key});

  @override
  State<ContentDirectorsScreen> createState() => ContentDirectorsScreenState();
}

class ContentDirectorsScreenState extends State<ContentDirectorsScreen> {
  late final PDCompanyRepository _pdCompanyRepository;
  late final ContentDirectorRepository _contentDirectorRepository;
  List<PDCompany> _pdCompanies = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final repositoryProvider = Provider.of<RepositoryProvider>(context, listen: false);
      _pdCompanyRepository = repositoryProvider.pdCompanyRepository;
      _contentDirectorRepository = repositoryProvider.contentDirectorRepository;
      _loadPDCompanies();
    }
  }

  Future<void> _loadPDCompanies() async {
    final companies = await _pdCompanyRepository.getPDCompanies();
    setState(() {
      _pdCompanies = companies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider(
      create: (_) => ContentDirectorModel(
        _contentDirectorRepository,
        _pdCompanies,
        _pdCompanyRepository.updatePDCompany,
      ),
      child: Consumer<ContentDirectorModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBarComponent(
                      key: const ValueKey('search_content_directors'),
                      hintText: 'Search content directors',
                      onSearch: (query) => model.search(query),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context, model),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Content Director'),
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
                child: ContentDirectorsTableWidget(
                  contentDirectors: model.contentDirectors,
                  onDelete: (id) => model.deleteContentDirector(id),
                  onEdit: (director) => _showEditDialog(context, model, director),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, ContentDirectorModel model) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AddContentDirectorDialog(
        onAdd: (director) => model.addContentDirector(director),
        availableCompanies: _pdCompanies,
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, ContentDirectorModel model, ContentDirector director) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => EditContentDirectorDialog(
        contentDirector: director,
        onSave: (director) => model.updateContentDirector(director),
        availableCompanies: _pdCompanies,
      ),
    );
  }
}