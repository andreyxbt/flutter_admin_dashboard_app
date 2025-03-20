import '../entities/pd_company.dart';

abstract class PDCompanyRepository {
  Future<List<PDCompany>> getCompanies();
  Future<void> addCompany(PDCompany company);
  Future<void> updateCompany(PDCompany company);
  Future<void> deleteCompany(String id);
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