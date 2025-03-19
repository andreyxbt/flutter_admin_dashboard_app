import 'package:flutter/material.dart';
import '../entities/organization.dart';
import '../screens/edit_organization_screen.dart';

class OrganizationsTableComponent extends StatefulWidget {
  const OrganizationsTableComponent({super.key});

  @override
  State<OrganizationsTableComponent> createState() => OrganizationsTableComponentState();
}

class OrganizationsTableComponentState extends State<OrganizationsTableComponent> {
  final List<Organization> _allOrganizations = [
    Organization(name: 'Acme Inc.', description: 'Leading manufacturer of cartoon products', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Widgets Co.', description: 'Premium widget solutions', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Globex Corp.', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Initech LLC.', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Umbrella Corp.', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Soylent Green', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Cyberdyne Systems', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Tyrell Corporation', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Gringotts Bank', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
    Organization(name: 'Wonka Industries', users: '2', courses: '3', lessons: '4', quizzes: '5', assignments: '6', reports: '7', lastUpdated: '8'),
  ];
  
  List<Organization> _filteredOrganizations = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredOrganizations = _allOrganizations;
  }

  void filterOrganizations(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredOrganizations = _allOrganizations
          .where((org) => org.name.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  void _deleteOrganization(Organization org) {
    setState(() {
      _allOrganizations.remove(org);
      _filteredOrganizations.remove(org);
    });
  }

  void _editOrganization(Organization oldOrg, Organization newOrg) {
    setState(() {
      final index = _allOrganizations.indexOf(oldOrg);
      if (index != -1) {
        _allOrganizations[index] = newOrg;
      }
      
      final filteredIndex = _filteredOrganizations.indexOf(oldOrg);
      if (filteredIndex != -1) {
        _filteredOrganizations[filteredIndex] = newOrg;
      }
    });
  }

  Future<void> _showEditDialog(Organization org) async {
    await showDialog(
      context: context,
      builder: (context) => EditOrganizationScreen(
        organization: org,
        onSave: (updatedOrg) => _editOrganization(org, updatedOrg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOrganizations.length,
              itemBuilder: (context, index) {
                return _buildRow(_filteredOrganizations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Name', flex: 2),
          _buildHeaderCell('Users'),
          _buildHeaderCell('Courses'),
          _buildHeaderCell('Lessons'),
          _buildHeaderCell('Quizzes'),
          _buildHeaderCell('Assignments', flex: 2),
          _buildHeaderCell('Reports'),
          _buildHeaderCell('Last updated', flex: 2),
          _buildHeaderCell('Actions'),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0D141C),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Organization org) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E8EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildCell(org.name, flex: 2, isName: true),
          _buildCell(org.users),
          _buildCell(org.courses),
          _buildCell(org.lessons),
          _buildCell(org.quizzes),
          _buildCell(org.assignments, flex: 2),
          _buildCell(org.reports),
          _buildCell(org.lastUpdated, flex: 2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF4F7396)),
                    onPressed: () => _showEditDialog(org),
                    tooltip: 'Edit organization',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFF4F7396)),
                    onPressed: () => _showDeleteConfirmation(org),
                    tooltip: 'Delete organization',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, bool isName = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 72,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isName ? const Color(0xFF0D141C) : const Color(0xFF4F7396),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Organization org) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Organization'),
          content: Text('Are you sure you want to delete ${org.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteOrganization(org);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

