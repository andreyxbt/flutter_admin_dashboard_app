import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/screens/placeholder_screen.dart';
import 'package:flutter_admin_dashboard_app/ui/views/pd_companies_table_component.dart';
import 'package:flutter_admin_dashboard_app/ui/views/schools_table_component.dart';
import 'widgets/sidebar_component.dart';
import 'widgets/header_component.dart';
import 'widgets/search_bar_component.dart';
import 'entities/organization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NavigationItem _selectedItem = NavigationItem.dashboard;
  final _schoolsTableKey = GlobalKey<SchoolsTableComponentState>();
  final _pdCompaniesTableKey = GlobalKey<PDCompaniesTableComponentState>();

  String _getTitle(NavigationItem item) {
    switch (item) {
      case NavigationItem.dashboard:
        return 'Dashboard';
      case NavigationItem.users:
        return 'Users';
      case NavigationItem.courses:
        return 'Courses';
      case NavigationItem.assignments:
        return 'Assignments';
      case NavigationItem.schools:
        return 'Schools';
      case NavigationItem.pdCompanies:
        return 'PD Companies';
      case NavigationItem.reports:
        return 'Reports';
    }
  }

  String _getSubtitle(NavigationItem item) {
    switch (item) {
      case NavigationItem.dashboard:
        return 'Overview of system statistics';
      case NavigationItem.users:
        return 'Manage system users';
      case NavigationItem.courses:
        return 'Browse and manage courses';
      case NavigationItem.assignments:
        return 'View and manage assignments';
      case NavigationItem.schools:
        return 'Manage schools in the system';
      case NavigationItem.pdCompanies:
        return 'Manage professional development companies';
      case NavigationItem.reports:
        return 'View and generate reports';
    }
  }

  Widget _buildContent() {
    if (_selectedItem == NavigationItem.schools) {
      return Column(
        key: ValueKey(_selectedItem),
        children: [
          SearchBarComponent(
            key: const ValueKey('search_schools'),
            hintText: 'Search schools',
            onSearch: (query) => _schoolsTableKey.currentState?.onSearch(query),
          ),
          Expanded(
            child: SchoolsTableComponent(
              key: _schoolsTableKey,
            ),
          ),
        ],
      );
    } else if (_selectedItem == NavigationItem.pdCompanies) {
      return Column(
        key: ValueKey(_selectedItem),
        children: [
          SearchBarComponent(
            key: const ValueKey('search_pd_companies'),
            hintText: 'Search PD companies',
            onSearch: (query) => _pdCompaniesTableKey.currentState?.onSearch(query),
          ),
          Expanded(
            child: PDCompaniesTableComponent(
              key: _pdCompaniesTableKey,
            ),
          ),
        ],
      );
    }
    return PlaceholderScreen(
      key: ValueKey(_selectedItem),
      title: _getTitle(_selectedItem),
    );
  }

  void _handleAddOrganization(Organization? organization) {
    if (organization == null) return;

    if (organization is School) {
      _schoolsTableKey.currentState?.addSchool(organization);
    } else if (organization is PDCompany) {
      _pdCompaniesTableKey.currentState?.addCompany(organization);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarComponent(
            selectedItem: _selectedItem,
            onNavigationChanged: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
            onAddOrganization: _handleAddOrganization,
          ),
          Expanded(
            child: Column(
              children: [
                HeaderComponent(
                  title: _getTitle(_selectedItem),
                  subtitle: _getSubtitle(_selectedItem),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

