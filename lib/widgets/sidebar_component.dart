import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/entities/pd_company.dart';
import 'package:flutter_admin_dashboard_app/entities/school.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../entities/organization.dart';
import '../models/navigation_item.dart';

class SidebarComponent extends StatelessWidget {
  final NavigationItem selectedItem;
  final Function(NavigationItem) onNavigationChanged;
  final Function(Organization)? onAddOrganization;

  const SidebarComponent({
    super.key, 
    required this.selectedItem,
    required this.onNavigationChanged,
    this.onAddOrganization,
  });

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
      width: 256,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildNavigationItem(
            NavigationItem.dashboard,
            'Daschboard',
            'assets/icons/home_icon.svg',
          ),
          _buildNavigationItem(
            NavigationItem.pdCompanies,
            'PD Companies',
            'assets/icons/organisations_icon.svg',
          ),
          _buildNavigationItem(
            NavigationItem.schools,
            'Schools',
            'assets/icons/organisations_icon.svg',
          ),
          _buildNavigationItem(
            NavigationItem.users,
            'Users',
            'assets/icons/users_icon.svg',
          ),
          _buildNavigationItem(
            NavigationItem.courses,
            'Courses',
            'assets/icons/courses_icon.svg',
          ),
          _buildNavigationItem(
            NavigationItem.assignments,
            'Assignments',
            'assets/icons/assignments_icon.svg',
          ),
          _buildNavigationItem(
            NavigationItem.reports,
            'Reports',
            'assets/icons/reports_icon.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(NavigationItem item, String title, String iconPath) {
    final isSelected = selectedItem == item;
    return InkWell(
      onTap: () => onNavigationChanged(item),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4F9) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF1A91F0) : const Color(0xFF4F7396),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? const Color(0xFF1A91F0) : const Color(0xFF4F7396),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

