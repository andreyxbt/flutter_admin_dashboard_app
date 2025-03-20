import 'package:flutter/material.dart';
import '../entities/organization.dart';
import '../entities/school.dart';
import '../entities/pd_company.dart';
import '../screens/edit_organization_screen.dart';

class OrganizationsTableComponent extends StatefulWidget {
  final bool isSchools;
  final List<Organization> organizations;

  const OrganizationsTableComponent({
    super.key,
    required this.isSchools,
    required this.organizations,
  });

  @override
  State<OrganizationsTableComponent> createState() => OrganizationsTableComponentState();
}

class OrganizationsTableComponentState extends State<OrganizationsTableComponent> {
  late List<Organization> _allOrganizations;
  List<Organization> _filteredOrganizations = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allOrganizations = List.from(widget.organizations);
    _filteredOrganizations = _allOrganizations.where((org) =>
      widget.isSchools ? org is School : org is PDCompany
    ).toList();
  }

  @override
  void didUpdateWidget(OrganizationsTableComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.organizations != widget.organizations || oldWidget.isSchools != widget.isSchools) {
      _allOrganizations = List.from(widget.organizations);
      _filteredOrganizations = _allOrganizations.where((org) =>
        widget.isSchools ? org is School : org is PDCompany
      ).toList();
    }
  }

  void filterOrganizations(String query) {
    if (!mounted) return;
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredOrganizations = _allOrganizations
          .where((org) => 
            (widget.isSchools ? org is School : org is PDCompany) &&
            org.name.toLowerCase().contains(_searchQuery))
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

  void updateOrganizations(List<Organization> newOrganizations) {
    setState(() {
      _allOrganizations = List.from(newOrganizations);
      _filteredOrganizations = _allOrganizations.where((org) =>
        widget.isSchools ? org is School : org is PDCompany
      ).toList();
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

