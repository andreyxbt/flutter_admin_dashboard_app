import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../entities/organization.dart';

enum NavigationItem {
  dashboard,
  users,
  courses,
  assignments,
  schools,
  pdCompanies,
  reports
}

class SidebarComponent extends StatelessWidget {
  final NavigationItem selectedItem;
  final Function(NavigationItem) onNavigationChanged;
  final Function(Organization)? onAddOrganization;

  const SidebarComponent({
    Key? key, 
    required this.selectedItem,
    required this.onNavigationChanged,
    this.onAddOrganization,
  }) : super(key: key);

  void _showAddDialog(BuildContext context) async {
    String type = selectedItem == NavigationItem.schools ? 'School' : 'PD Company';
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final usersController = TextEditingController();
    final coursesController = TextEditingController();
    final reportsController = TextEditingController();

    final result = await showDialog<Organization>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New $type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usersController,
                decoration: const InputDecoration(
                  labelText: 'Users',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: coursesController,
                decoration: const InputDecoration(
                  labelText: 'Courses',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reportsController,
                decoration: const InputDecoration(
                  labelText: 'Reports',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                return;
              }

              final now = DateTime.now();
              final organization = selectedItem == NavigationItem.schools
                  ? School(
                      id: now.millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      description: descriptionController.text,
                      users: usersController.text,
                      courses: coursesController.text,
                      reports: reportsController.text,
                      lastUpdated: now.toString().substring(0, 10),
                    )
                  : PDCompany(
                      id: now.millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      description: descriptionController.text,
                      users: usersController.text,
                      courses: coursesController.text,
                      reports: reportsController.text,
                      lastUpdated: now.toString().substring(0, 10),
                    );

              Navigator.of(context).pop(organization);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A80E5),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result != null && onAddOrganization != null) {
      onAddOrganization!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      color: const Color(0xFFF7FAFC),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavItem(
                  'Dashboard', 
                  'assets/icons/home_icon.svg',
                  NavigationItem.dashboard,
                ),
                _buildNavItem(
                  'Users', 
                  'assets/icons/users_icon.svg',
                  NavigationItem.users,
                ),
                _buildNavItem(
                  'Courses', 
                  'assets/icons/courses_icon.svg',
                  NavigationItem.courses,
                ),
                _buildNavItem(
                  'Assignments', 
                  'assets/icons/assignments_icon.svg',
                  NavigationItem.assignments,
                ),
                _buildNavItem(
                  'Schools', 
                  'assets/icons/organisations_icon.svg',
                  NavigationItem.schools,
                ),
                _buildNavItem(
                  'PD Companies', 
                  'assets/icons/organisations_icon.svg',
                  NavigationItem.pdCompanies,
                ),
                _buildNavItem(
                  'Reports', 
                  'assets/icons/reports_icon.svg',
                  NavigationItem.reports,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (selectedItem == NavigationItem.schools || selectedItem == NavigationItem.pdCompanies)
            ElevatedButton(
              onPressed: () => _showAddDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A80E5),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'New ${selectedItem == NavigationItem.schools ? 'School' : 'PD Company'}',
                style: const TextStyle(
                  color: Color(0xFFF7FAFC),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, String? iconPath, NavigationItem item) {
    final isSelected = selectedItem == item;
    
    return InkWell(
      onTap: () => onNavigationChanged(item),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EDF2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Color(0xFF0D141C), BlendMode.srcIn),
                )
              else
                const Icon(
                  Icons.circle,
                  size: 24,
                  color: Color(0xFF0D141C),
                ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0D141C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

