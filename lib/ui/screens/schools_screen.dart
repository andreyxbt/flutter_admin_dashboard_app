import 'package:flutter/material.dart';
import '../components/schools_table_component.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  @override
  Widget build(BuildContext context) {
    return const SchoolsTableComponent();
  }
}