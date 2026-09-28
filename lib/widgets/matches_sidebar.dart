import 'package:flutter/material.dart';

class MatchesSidebar extends StatelessWidget {
  const MatchesSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مواعيد المباريات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: const [
                Text('د.مصر', style: TextStyle(fontSize: 11, color: Colors.red)),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('بيراميدز', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('VS', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('الشرقية للدخان', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('08:00 - 2026/9/17', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}