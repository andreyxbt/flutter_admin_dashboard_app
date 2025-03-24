import 'dart:convert';
import '../entities/pd_company.dart';
import '../services/shared_preferences_service.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

abstract class PDCompanyRepository implements BaseRepository<PDCompany> {
  Future<List<PDCompany>> getPDCompanies();
  Future<PDCompany?> getPDCompany(String id);
  Future<String> addPDCompany(PDCompany company);
  Future<void> updatePDCompany(PDCompany company);
  Future<void> deletePDCompany(String id);
  Future<List<PDCompany>> searchPDCompanies(String query);
}

class PersistentPDCompanyRepository implements PDCompanyRepository {
  static const String _storageKey = 'pd_companies';
  final SharedPreferencesService _prefsService;
  final FirestorePDCompanyRepository _firebaseRepo;
  List<PDCompany> _cachedCompanies = [];
  bool _initialized = false;

  PersistentPDCompanyRepository(this._prefsService, this._firebaseRepo);

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _loadFromCache();
      _initialized = true;
    }
  }

  Future<void> _loadFromCache() async {
    final jsonStr = _prefsService.getString(_storageKey);
    if (jsonStr != null) {
      final jsonList = jsonDecode(jsonStr) as List;
      _cachedCompanies = jsonList.map((json) => PDCompany.fromJson(json)).toList();
    }
  }

  Future<void> _saveToCache(List<PDCompany> companies) async {
    final jsonList = companies.map((company) => company.toJson()).toList();
    await _prefsService.setString(_storageKey, jsonEncode(jsonList));
    _cachedCompanies = companies;
  }

  @override
  Future<List<PDCompany>> getPDCompanies() async {
    try {
      final companies = await _firebaseRepo.getAll();
      await _saveToCache(companies);
      return companies;
    } catch (e) {
      await _ensureInitialized();
      return List.from(_cachedCompanies);
    }
  }

  @override
  Future<PDCompany?> getPDCompany(String id) async {
    try {
      final company = await _firebaseRepo.getById(id);
      if (company != null) {
        await _ensureInitialized();
        final index = _cachedCompanies.indexWhere((c) => c.id == id);
        if (index >= 0) {
          _cachedCompanies[index] = company;
        } else {
          _cachedCompanies.add(company);
        }
        await _saveToCache(_cachedCompanies);
      }
      return company;
    } catch (e) {
      await _ensureInitialized();
      return _cachedCompanies.firstWhereOrNull((c) => c.id == id);
    }
  }

  @override
  Future<String> addPDCompany(PDCompany company) async {
    final id = await _firebaseRepo.add(company);
    company = company.copyWith(id: id);
    await _ensureInitialized();
    _cachedCompanies.add(company);
    await _saveToCache(_cachedCompanies);
    return id;
  }

  @override
  Future<void> updatePDCompany(PDCompany company) async {
    await _firebaseRepo.update(company.id, company);
    await _ensureInitialized();
    final index = _cachedCompanies.indexWhere((c) => c.id == company.id);
    if (index >= 0) {
      _cachedCompanies[index] = company;
      await _saveToCache(_cachedCompanies);
    }
  }

  @override
  Future<void> deletePDCompany(String id) async {
    await _firebaseRepo.delete(id);
    await _ensureInitialized();
    _cachedCompanies.removeWhere((c) => c.id == id);
    await _saveToCache(_cachedCompanies);
  }

  @override
  Future<List<PDCompany>> searchPDCompanies(String query) async {
    try {
      return await _firebaseRepo.searchPDCompanies(query);
    } catch (e) {
      await _ensureInitialized();
      query = query.toLowerCase();
      return _cachedCompanies.where((company) =>
        company.name.toLowerCase().contains(query) ||
        company.description.toLowerCase().contains(query)
      ).toList();
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefsService.remove(_storageKey);
    _cachedCompanies.clear();
    _initialized = false;
  }

  @override
  Future<List<PDCompany>> refreshFromRemote() async {
    final companies = await _firebaseRepo.getAll();
    await _saveToCache(companies);
    return companies;
  }

  @override
  Future<String> add(PDCompany item) => addPDCompany(item);

  @override
  Future<void> delete(String id) => deletePDCompany(id);

  @override
  Future<List<PDCompany>> getAll() => getPDCompanies();

  @override
  Future<PDCompany?> getById(String id) => getPDCompany(id);

  @override
  Future<void> update(String id, PDCompany item) => updatePDCompany(item);
}

class FirestorePDCompanyRepository extends FirebaseRepository<PDCompany> implements PDCompanyRepository {
  FirestorePDCompanyRepository({FirebaseFirestore? firestore}) 
      : super(collection: 'pd_companies', firestore: firestore);
  
  @override
  Map<String, dynamic> toMap(PDCompany company) => company.toJson();
  
  @override
  PDCompany fromMap(Map<String, dynamic> map, String id) {
    final mapCopy = Map<String, dynamic>.from(map);
    if (mapCopy['id'] == null || mapCopy['id'] != id) {
      mapCopy['id'] = id;
    }
    return PDCompany.fromJson(mapCopy);
  }
  
  Future<List<PDCompany>> searchPDCompanies(String query) async {
    query = query.toLowerCase();
    final allCompanies = await getAll();
    return allCompanies.where((company) =>
      company.name.toLowerCase().contains(query) ||
      company.description.toLowerCase().contains(query)
    ).toList();
  }
  
  @override
  Future<List<PDCompany>> getPDCompanies() => getAll();
  
  @override
  Future<PDCompany?> getPDCompany(String id) => getById(id);
  
  @override
  Future<String> addPDCompany(PDCompany company) async {
    return add(company);
  }
  
  @override
  Future<void> updatePDCompany(PDCompany company) async {
    await update(company.id, company);
  }
  
  @override
  Future<void> deletePDCompany(String id) async {
    await delete(id);
  }
}