import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'models/navigation_item.dart';
import 'ui/views/sidebar_component.dart';
import 'ui/screens/schools_screen.dart';
import 'ui/screens/pd_companies_screen.dart';
import 'ui/screens/teachers_screen.dart';
import 'ui/screens/content_directors_screen.dart';
import 'ui/screens/placeholder_screen.dart';
import 'ui/screens/login_screen.dart';
import 'services/shared_preferences_service.dart';
import 'services/auth_service.dart';
import 'repositories/repository_provider.dart';
import 'widgets/auth_wrapper.dart';
import 'widgets/user_profile_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to Firebase emulators in debug mode
  if (kDebugMode) {
    try {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      print('Connected to Firebase emulators');
    } catch (e) {
      print('Failed to connect to emulators: $e');
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final prefsService = SharedPreferencesService(prefs);
  final repositoryProvider = RepositoryProvider(prefsService);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferencesService>.value(
          value: prefsService,
        ),
        Provider<RepositoryProvider>.value(
          value: repositoryProvider,
        ),
      ],
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
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(child: DashboardScreen()),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
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
      case NavigationItem.teachers:
        return 'Teachers';
      case NavigationItem.contentDirectors:
        return 'Content Directors';
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
      case NavigationItem.teachers:
        return 'Manage teachers and their assignments';
      case NavigationItem.contentDirectors:
        return 'Manage content directors and their courses';
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
    final User? currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      // If user is not logged in, AuthWrapper should handle this,
      // but just in case we'll return an empty container
      return Container();
    }
    
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
                // Header with title and user profile
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                      // User profile widget
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: UserProfileWidget(
                          user: currentUser,
                          authService: _authService,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

