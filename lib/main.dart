import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/navigation_item.dart';
import 'models/school_model.dart';
import 'models/pd_company_model.dart';
import 'models/user_model.dart';
import 'repositories/school_repository.dart';
import 'repositories/pd_company_repository.dart';
import 'repositories/user_repository.dart';
import 'widgets/sidebar_component.dart';
import 'ui/views/schools_table_component.dart';
import 'ui/views/pd_companies_table_component.dart';
import 'ui/views/users_table_component.dart';
import 'screens/placeholder_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF7FAFC),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SchoolModel(InMemorySchoolRepository()),
          ),
          ChangeNotifierProvider(
            create: (_) => PDCompanyModel(InMemoryPDCompanyRepository()),
          ),
          ChangeNotifierProvider(
            create: (_) => UserModel(InMemoryUserRepository()),
          ),
        ],
        child: const DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NavigationItem _selectedItem = NavigationItem.dashboard;

  void _onNavigationChanged(NavigationItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

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
    switch (_selectedItem) {
      case NavigationItem.users:
        return const Expanded(
          child: UsersTableComponent(),
        );
      case NavigationItem.schools:
        return const Expanded(
          child: SchoolsTableComponent(),
        );
      case NavigationItem.pdCompanies:
        return const Expanded(
          child: PDCompaniesTableComponent(),
        );
      default:
        return PlaceholderScreen(title: _getTitle(_selectedItem));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarComponent(
            selectedItem: _selectedItem,
            onNavigationChanged: _onNavigationChanged,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(_selectedItem),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSubtitle(_selectedItem),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
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

