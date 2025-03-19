import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/widgets/organizations_table_component.dart';
import 'widgets/sidebar_component.dart';
import 'widgets/header_component.dart';
import 'widgets/search_bar_component.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final organizationsTableKey = GlobalKey<OrganizationsTableComponentState>();

    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            SidebarComponent(),
            Expanded(
              child: Column(
                children: [
                  HeaderComponent(),
                  SearchBarComponent(
                    onSearch: (query) {
                      organizationsTableKey.currentState?.filterOrganizations(query);
                    },
                  ),
                  Expanded(
                    child: OrganizationsTableComponent(key: organizationsTableKey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

