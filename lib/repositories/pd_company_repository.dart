import 'dart:convert';
import '../entities/pd_company.dart';
import '../services/shared_preferences_service.dart';

abstract class PDCompanyRepository {
  Future<List<PDCompany>> getCompanies();
  Future<void> addCompany(PDCompany company);
  Future<void> updateCompany(PDCompany company);
  Future<void> deleteCompany(String id);
}

class PersistentPDCompanyRepository implements PDCompanyRepository {
  final SharedPreferencesService _prefsService;
  static const String _storageKey = 'pd_companies';

  PersistentPDCompanyRepository(this._prefsService) {
    _initializeDefaultData();
  }

  Future<void> _initializeDefaultData() async {
    if (_prefsService.getString(_storageKey) == null) {
      final defaultCompanies = [
        PDCompany(
          id: '1',
          name: 'TeachFirst Solutions',
          description: 'Professional development for educators',
          users: '50',
          courses: '30',
          reports: '20',
          lastUpdated: '2023-12-01',
        ),
        PDCompany(
          id: '2',
          name: 'EduGrowth Partners',
          description: 'Specialized teacher training',
          users: '75',
          courses: '40',
          reports: '25',
          lastUpdated: '2023-12-02',
        ),
      ];
      
      await _saveCompanies(defaultCompanies);
    }
  }

  Future<void> _saveCompanies(List<PDCompany> companies) async {
    final jsonData = companies.map((company) => company.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonData));
  }

  @override
  Future<List<PDCompany>> getCompanies() async {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr == null) return [];
    
    final jsonData = jsonDecode(jsonStr) as List;
    return jsonData.map((json) => PDCompany.fromJson(json)).toList();
  }

  @override
  Future<void> addCompany(PDCompany company) async {
    final companies = await getCompanies();
    companies.add(company);
    await _saveCompanies(companies);
  }

  @override
  Future<void> updateCompany(PDCompany company) async {
    final companies = await getCompanies();
    final index = companies.indexWhere((c) => c.id == company.id);
    if (index != -1) {
      companies[index] = company;
      await _saveCompanies(companies);
    }
  }

  @override
  Future<void> deleteCompany(String id) async {
    final companies = await getCompanies();
    companies.removeWhere((company) => company.id == id);
    await _saveCompanies(companies);
  }
}

class InMemoryPDCompanyRepository implements PDCompanyRepository {
  final List<PDCompany> _companies = [
    PDCompany(
      id: '1',
      name: 'TeachFirst Solutions',
      description: 'Professional development for educators',
      users: '50',
      courses: '30',
      reports: '20',
      lastUpdated: '2023-12-01',
    ),
    PDCompany(
      id: '2',
      name: 'EduGrowth Partners',
      description: 'Specialized teacher training',
      users: '75',
      courses: '40',
      reports: '25',
      lastUpdated: '2023-12-02',
    ),
    // Add more initial companies as needed
  ];

  @override
  Future<List<PDCompany>> getCompanies() async => List.from(_companies);

  @override
  Future<void> addCompany(PDCompany company) async {
    _companies.add(company);
  }

  @override
  Future<void> updateCompany(PDCompany company) async {
    final index = _companies.indexWhere((c) => c.id == company.id);
    if (index != -1) {
      _companies[index] = company;
    }
  }

  @override
  Future<void> deleteCompany(String id) async {
    _companies.removeWhere((company) => company.id == id);
  }
}