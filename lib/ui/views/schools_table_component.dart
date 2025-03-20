import 'package:flutter/material.dart';
import '../../widgets/organizations_table_component.dart';
import '../../entities/school.dart';

class SchoolsDataProvider {
  static final List<School> schools = [
    School(
      id: '1',
      name: 'Acme High School',
      description: 'Leading high school for cartoon physics',
      users: '150',
      courses: '25',
      reports: '45',
      lastUpdated: '2023-12-01',
    ),
    School(
      id: '2',
      name: 'Springfield Elementary',
      description: 'Elementary school with character',
      users: '200',
      courses: '15',
      reports: '30',
      lastUpdated: '2023-12-02',
    ),
    School(
      id: '3',
      name: 'Tech Academy',
      description: 'STEM-focused charter school',
      users: '300',
      courses: '35',
      reports: '50',
      lastUpdated: '2023-12-03',
    ),
    School(
      id: '4',
      name: 'Global Learning Institute',
      description: 'International Baccalaureate World School',
      users: '450',
      courses: '40',
      reports: '60',
      lastUpdated: '2023-12-04',
    ),
    School(
      id: '5',
      name: 'Riverside Preparatory',
      description: 'College preparatory school with emphasis on arts',
      users: '280',
      courses: '30',
      reports: '40',
      lastUpdated: '2023-12-05',
    ),
    School(
      id: '6',
      name: 'Edison Science Academy',
      description: 'Advanced science and mathematics focused institution',
      users: '320',
      courses: '45',
      reports: '55',
      lastUpdated: '2023-12-06',
    ),
  ];
}

class SchoolsTableComponent extends StatefulWidget {
  final void Function(String)? onSearch;

  const SchoolsTableComponent({
    super.key,
    this.onSearch,
  });

  @override
  State<SchoolsTableComponent> createState() => SchoolsTableComponentState();
}

class SchoolsTableComponentState extends State<SchoolsTableComponent> {
  final _tableKey = GlobalKey<OrganizationsTableComponentState>();

  void addSchool(School school) {
    SchoolsDataProvider.schools.add(school);
    _tableKey.currentState?.updateOrganizations(SchoolsDataProvider.schools);
  }

  @override
  Widget build(BuildContext context) {
    return OrganizationsTableComponent(
      key: _tableKey,
      isSchools: true,
      organizations: SchoolsDataProvider.schools,
    );
  }

  void onSearch(String query) {
    _tableKey.currentState?.filterOrganizations(query);
  }
}
