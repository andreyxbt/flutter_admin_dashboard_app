import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Color(0xFF4F7396),
            ),
            const SizedBox(height: 24),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D141C),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This section is under construction',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4F7396),
              ),
            ),
          ],
        ),
      ),
    );
  }
}