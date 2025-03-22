import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/navigation_item.dart';

class SidebarComponent extends StatelessWidget {
  final NavigationItem selectedItem;
  final Function(NavigationItem) onNavigationChanged;

  const SidebarComponent({
    super.key, 
    required this.selectedItem,
    required this.onNavigationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildNavigationItem(
            context,
            NavigationItem.dashboard,
            'Home',
            'assets/icons/home_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.teachers,
            'Teachers',
            'assets/icons/users_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.contentDirectors,
            'Content Directors',
            'assets/icons/users_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.courses,
            'Courses',
            'assets/icons/courses_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.assignments,
            'Assignments',
            'assets/icons/assignments_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.schools,
            'Schools',
            'assets/icons/organisations_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.pdCompanies,
            'PD Companies',
            'assets/icons/organisations_icon.svg',
          ),
          _buildNavigationItem(
            context,
            NavigationItem.reports,
            'Reports',
            'assets/icons/reports_icon.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    String title,
    String iconPath,
  ) {
    final isSelected = selectedItem == item;

    return InkWell(
      onTap: () => onNavigationChanged(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4F9) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? const Color(0xFF0D141C) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF0D141C) : const Color(0xFF64748B),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0D141C) : const Color(0xFF64748B),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

