import 'dart:convert';
import '../entities/pd_company.dart';
import '../services/shared_preferences_service.dart';

abstract class PDCompanyRepository {
  Future<List<PDCompany>> getPDCompanies();
  Future<PDCompany?> getPDCompany(String id);
  Future<void> addPDCompany(PDCompany company);
  Future<void> updatePDCompany(PDCompany company);
  Future<void> deletePDCompany(String id);
}

class PersistentPDCompanyRepository implements PDCompanyRepository {
  static const String _storageKey = 'pd_companies';
  final SharedPreferencesService _prefsService;
  List<PDCompany> _pdCompanies = [];
  bool _initialized = false;

  PersistentPDCompanyRepository(this._prefsService);

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _initializeDefaultData();
      _initialized = true;
    }
  }

  Future<void> _initializeDefaultData() async {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr == null) {
      _pdCompanies = [
        PDCompany(
          id: '1',
          name: 'Example PD Company',
          description: 'A professional development company',
          users: '5',
          courses: '10',
          reports: '15',
          lastUpdated: DateTime.now().toIso8601String(),
          userIds: [],
        ),
        PDCompany(
          id: '2',
          name: 'Another PD Company',
          description: 'Another professional development company',
          users: '3',
          courses: '7',
          reports: '12',
          lastUpdated: DateTime.now().toIso8601String(),
          userIds: [],
        ),
      ];
      await _savePDCompanies();
    } else {
      final jsonList = jsonDecode(jsonStr) as List;
      _pdCompanies = jsonList.map((json) => PDCompany.fromJson(json)).toList();
    }
  }

  Future<void> _savePDCompanies() async {
    final jsonList = _pdCompanies.map((company) => company.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
  }

  @override
  Future<List<PDCompany>> getPDCompanies() async {
    await _ensureInitialized();
    return List.from(_pdCompanies);
  }

  @override
  Future<PDCompany?> getPDCompany(String id) async {
    await _ensureInitialized();
    try {
      return _pdCompanies.firstWhere((company) => company.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addPDCompany(PDCompany company) async {
    await _ensureInitialized();
    _pdCompanies.add(company);
    await _savePDCompanies();
  }

  @override
  Future<void> updatePDCompany(PDCompany company) async {
    await _ensureInitialized();
    final index = _pdCompanies.indexWhere((c) => c.id == company.id);
    if (index != -1) {
      _pdCompanies[index] = company;
      await _savePDCompanies();
    }
  }

  @override
  Future<void> deletePDCompany(String id) async {
    await _ensureInitialized();
    _pdCompanies.removeWhere((company) => company.id == id);
    await _savePDCompanies();
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
  ];

  @override
  Future<List<PDCompany>> getPDCompanies() async => List.from(_companies);

  @override
  Future<PDCompany?> getPDCompany(String id) async {
    try {
      return _companies.firstWhere((company) => company.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addPDCompany(PDCompany company) async {
    _companies.add(company);
  }

  @override
  Future<void> updatePDCompany(PDCompany company) async {
    final index = _companies.indexWhere((c) => c.id == company.id);
    if (index != -1) {
      _companies[index] = company;
    }
  }

  @override
  Future<void> deletePDCompany(String id) async {
    _companies.removeWhere((company) => company.id == id);
  }
}