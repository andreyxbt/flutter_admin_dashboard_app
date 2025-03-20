import 'package:flutter/foundation.dart';
import '../entities/pd_company.dart';
import '../repositories/pd_company_repository.dart';

class PDCompanyModel extends ChangeNotifier {
  final PDCompanyRepository _repository;
  List<PDCompany> _companies = [];
  String _searchQuery = '';

  PDCompanyModel(this._repository) {
    _loadCompanies();
  }

  List<PDCompany> get companies => _searchQuery.isEmpty 
    ? _companies 
    : _companies.where((company) => 
        company.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        company.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();

  Future<void> _loadCompanies() async {
    _companies = await _repository.getCompanies();
    notifyListeners();
  }

  Future<void> addCompany(PDCompany company) async {
    await _repository.addCompany(company);
    await _loadCompanies();
  }

  Future<void> updateCompany(PDCompany company) async {
    await _repository.updateCompany(company);
    await _loadCompanies();
  }

  Future<void> deleteCompany(String id) async {
    await _repository.deleteCompany(id);
    await _loadCompanies();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}