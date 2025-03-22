import 'package:flutter/material.dart';
import '../entities/content_director.dart';
import '../entities/pd_company.dart';
import '../repositories/content_director_repository.dart';

class ContentDirectorModel extends ChangeNotifier {
  final ContentDirectorRepository _repository;
  final List<PDCompany> _pdCompanies;
  final Future<void> Function(PDCompany) _updatePDCompany;
  List<ContentDirector> _contentDirectors = [];
  List<ContentDirector> _filteredDirectors = [];
  String _searchQuery = '';

  ContentDirectorModel(this._repository, this._pdCompanies, this._updatePDCompany) {
    _loadContentDirectors();
  }

  List<ContentDirector> get contentDirectors => _filteredDirectors;

  Future<void> _loadContentDirectors() async {
    _contentDirectors = await _repository.getContentDirectors();
    _applySearch();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
  }

  void _applySearch() {
    _filteredDirectors = _contentDirectors.where((director) =>
      director.name.toLowerCase().contains(_searchQuery) ||
      director.email.toLowerCase().contains(_searchQuery) ||
      (director.organizationName?.toLowerCase() ?? '').contains(_searchQuery)
    ).toList();
    notifyListeners();
  }

  Future<void> addContentDirector(ContentDirector director) async {
    await _repository.addContentDirector(director);
    if (director.orgId != null) {
      try {
        final company = _pdCompanies.firstWhere(
          (company) => company.id == director.orgId,
        );
        final updatedCompany = company.copyWith();
        updatedCompany.addUser(director.userId);
        await _updatePDCompany(updatedCompany);
      } catch (_) {
        // Company not found, continue with director addition
      }
    }
    await _loadContentDirectors();
  }

  Future<void> updateContentDirector(ContentDirector director) async {
    final oldDirector = _contentDirectors.firstWhere((d) => d.userId == director.userId);

    // Remove director from old company if there was one
    if (oldDirector.orgId != null) {
      try {
        final oldCompany = _pdCompanies.firstWhere(
          (company) => company.id == oldDirector.orgId,
        );
        final updatedOldCompany = oldCompany.copyWith();
        updatedOldCompany.removeUser(oldDirector.userId);
        await _updatePDCompany(updatedOldCompany);
      } catch (_) {
        // Old company not found, continue
      }
    }

    // Add director to new company if there is one
    if (director.orgId != null) {
      try {
        final newCompany = _pdCompanies.firstWhere(
          (company) => company.id == director.orgId,
        );
        final updatedNewCompany = newCompany.copyWith();
        updatedNewCompany.addUser(director.userId);
        await _updatePDCompany(updatedNewCompany);
      } catch (_) {
        // New company not found, continue
      }
    }

    await _repository.updateContentDirector(director);
    await _loadContentDirectors();
  }

  Future<void> deleteContentDirector(String id) async {
    final director = _contentDirectors.firstWhere((d) => d.userId == id);
    if (director.orgId != null) {
      try {
        final company = _pdCompanies.firstWhere(
          (company) => company.id == director.orgId,
        );
        final updatedCompany = company.copyWith();
        updatedCompany.removeUser(director.userId);
        await _updatePDCompany(updatedCompany);
      } catch (_) {
        // Company not found, continue with director deletion
      }
    }
    await _repository.deleteContentDirector(id);
    await _loadContentDirectors();
  }
}