import 'package:flutter/material.dart';
import '../entities/pd_company.dart';
import '../repositories/pd_company_repository.dart';

class PDCompanyModel extends ChangeNotifier {
  final PDCompanyRepository _repository;
  List<PDCompany> _companies = [];
  List<PDCompany> _filteredCompanies = [];
  String _searchQuery = '';
  bool _isLoading = false;

  PDCompanyModel(this._repository) {
    _loadCompanies();
  }

  List<PDCompany> get companies => _filteredCompanies;
  bool get isLoading => _isLoading;

  Future<void> _loadCompanies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _companies = await _repository.getPDCompanies();
      _filteredCompanies = List.from(_companies);
    } catch (e) {
      debugPrint('Error loading PD companies: $e');
      _companies = [];
      _filteredCompanies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _filteredCompanies = _companies.where((company) =>
      company.name.toLowerCase().contains(_searchQuery) ||
      company.description.toLowerCase().contains(_searchQuery)
    ).toList();
    notifyListeners();
  }

  Future<void> addPDCompany(PDCompany company) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addPDCompany(company);
      await _loadCompanies();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePDCompany(PDCompany company) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updatePDCompany(company);
      await _loadCompanies();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePDCompany(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deletePDCompany(id);
      await _loadCompanies();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}