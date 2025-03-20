import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/ui/views/pd_companies_table_component.dart';

class PDCompaniesScreen extends StatefulWidget {
  const PDCompaniesScreen({super.key});

  @override
  State<PDCompaniesScreen> createState() => _PDCompaniesScreenState();
}

class _PDCompaniesScreenState extends State<PDCompaniesScreen> {
  @override
  Widget build(BuildContext context) {
    return const PDCompaniesTableComponent();
  }
}