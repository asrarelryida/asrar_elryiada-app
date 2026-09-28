import 'package:flutter/material.dart';

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'مرحباً بكِ في لوحة تحكم أسرار الرياضة 👋',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB71C1C),
        ),
      ),
    );
  }
}