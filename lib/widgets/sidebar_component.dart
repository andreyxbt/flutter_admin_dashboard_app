import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SidebarComponent extends StatelessWidget {
  const SidebarComponent({Key? key}) : super(key: key);

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
                _buildNavItem('Dashboard', 'assets/icons/home_icon.svg'),
                _buildNavItem('Users', 'assets/icons/users_icon.svg'),
                _buildNavItem('Courses', 'assets/icons/courses_icon.svg'),
                _buildNavItem('Assignments', 'assets/icons/assignments_icon.svg'),
                _buildNavItem('Organizations', 'assets/icons/organisations_icon.svg', isSelected: true),
                _buildNavItem('Reports', 'assets/icons/reports_icon.svg'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A80E5),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'New organization',
              style: TextStyle(
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

  Widget _buildNavItem(String title, String? iconPath, {bool isSelected = false}) {
    return Container(
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
    );
  }
}

