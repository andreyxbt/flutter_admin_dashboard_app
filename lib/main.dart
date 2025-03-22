import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'models/navigation_item.dart';
import 'ui/views/sidebar_component.dart';
import 'ui/screens/schools_screen.dart';
import 'ui/screens/pd_companies_screen.dart';
import 'ui/screens/users_screen.dart';
import 'ui/screens/teachers_screen.dart';
import 'ui/screens/content_directors_screen.dart';
import 'ui/screens/placeholder_screen.dart';
import 'services/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final prefsService = SharedPreferencesService(prefs);
  
  runApp(
    Provider<SharedPreferencesService>.value(
      value: prefsService,
      child: const MyApp(),
    ),
  );
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
      home: const DashboardScreen(),
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
      case NavigationItem.teachers:
        return 'Teachers';
      case NavigationItem.contentDirectors:
        return 'Content Directors';
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
      case NavigationItem.teachers:
        return 'Manage teachers and their assignments';
      case NavigationItem.contentDirectors:
        return 'Manage content directors and their courses';
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
          child: UsersScreen(),
        );
      case NavigationItem.teachers:
        return const Expanded(
          child: TeachersScreen(),
        );
      case NavigationItem.contentDirectors:
        return const Expanded(
          child: ContentDirectorsScreen(),
        );
      case NavigationItem.schools:
        return const Expanded(
          child: SchoolsScreen(),
        );
      case NavigationItem.pdCompanies:
        return const Expanded(
          child: PDCompaniesScreen(),
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
                _buildContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

