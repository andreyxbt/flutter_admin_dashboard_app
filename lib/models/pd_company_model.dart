import 'package:flutter/material.dart';
import '../entities/pd_company.dart';
import '../repositories/pd_company_repository.dart';

class PDCompanyModel extends ChangeNotifier {
  final PDCompanyRepository _repository;
  List<PDCompany> _pdCompanies = [];
  List<PDCompany> _filteredCompanies = [];
  String _searchQuery = '';

  PDCompanyModel(this._repository) {
    _loadPDCompanies();
  }

  List<PDCompany> get pdCompanies => _filteredCompanies;

  Future<void> _loadPDCompanies() async {
    _pdCompanies = await _repository.getPDCompanies();
    _applySearch();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
  }

  void _applySearch() {
    _filteredCompanies = _pdCompanies.where((company) =>
      company.name.toLowerCase().contains(_searchQuery) ||
      company.description.toLowerCase().contains(_searchQuery)
    ).toList();
    notifyListeners();
  }

  Future<void> addPDCompany(PDCompany company) async {
    await _repository.addPDCompany(company);
    await _loadPDCompanies();
  }

  Future<void> updatePDCompany(PDCompany company) async {
    await _repository.updatePDCompany(company);
    await _loadPDCompanies();
  }

  Future<void> deletePDCompany(String id) async {
    await _repository.deletePDCompany(id);
    await _loadPDCompanies();
  }
}