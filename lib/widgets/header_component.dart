import 'package:flutter/material.dart';

class HeaderComponent extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderComponent({
    Key? key,
    this.title = 'Organizations',
    this.subtitle = 'Create, Read, Update, and Delete organizations',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              height: 40/32, // lineHeight / fontSize
              color: Color(0xFF0D141C),
            ),
          ),
          const SizedBox(height: 12), // gap between text elements
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              height: 21/14, // lineHeight / fontSize
              color: Color(0xFF4F7396),
            ),
          ),
        ],
      ),
    );
  }
}

