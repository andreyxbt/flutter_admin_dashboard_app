import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/school_model.dart';
import '../../repositories/school_repository.dart';
import '../views/schools_table_component.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  late final SchoolRepository _schoolRepository;

  @override
  void initState() {
    super.initState();
    _initRepository();
  }

  Future<void> _initRepository() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _schoolRepository = CachedSchoolRepository(prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_schoolRepository == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider(
      create: (_) => SchoolModel(_schoolRepository),
      child: const SchoolsTableComponent(),
    );
  }
}