import 'package:flutter/material.dart';
import '../../widgets/organizations_table_component.dart';
import '../../entities/organization.dart';

class PDCompaniesDataProvider {
  static final List<Organization> companies = [
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
    PDCompany(
      id: '3',
      name: 'InnovateEd',
      description: 'Innovation in educational technology training',
      users: '120',
      courses: '45',
      reports: '35',
      lastUpdated: '2023-12-03',
    ),
    PDCompany(
      id: '4',
      name: 'LeadershipLab Education',
      description: 'Educational leadership and management training',
      users: '90',
      courses: '35',
      reports: '30',
      lastUpdated: '2023-12-04',
    ),
    PDCompany(
      id: '5',
      name: 'Digital Teaching Pro',
      description: 'Digital literacy and online teaching strategies',
      users: '150',
      courses: '50',
      reports: '40',
      lastUpdated: '2023-12-05',
    ),
    PDCompany(
      id: '6',
      name: 'STEM Education Plus',
      description: 'STEM teaching methodology and curriculum development',
      users: '85',
      courses: '38',
      reports: '28',
      lastUpdated: '2023-12-06',
    ),
  ];
}

class PDCompaniesTableComponent extends StatefulWidget {
  final void Function(String)? onSearch;

  const PDCompaniesTableComponent({
    super.key,
    this.onSearch,
  });

  @override
  State<PDCompaniesTableComponent> createState() => PDCompaniesTableComponentState();
}

class PDCompaniesTableComponentState extends State<PDCompaniesTableComponent> {
  final _tableKey = GlobalKey<OrganizationsTableComponentState>();

  void addCompany(Organization company) {
    PDCompaniesDataProvider.companies.add(company);
    _tableKey.currentState?.updateOrganizations(PDCompaniesDataProvider.companies);
  }

  @override
  Widget build(BuildContext context) {
    return OrganizationsTableComponent(
      key: _tableKey,
      isSchools: false,
      organizations: PDCompaniesDataProvider.companies,
    );
  }

  void onSearch(String query) {
    _tableKey.currentState?.filterOrganizations(query);
  }
}
