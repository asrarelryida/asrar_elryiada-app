import 'package:flutter/material.dart';

class MatchesTabsBanner extends StatefulWidget {
  const MatchesTabsBanner({super.key});

  @override
  State<MatchesTabsBanner> createState() => _MatchesTabsBannerState();
}

class _MatchesTabsBannerState extends State<MatchesTabsBanner> {
  String selectedDay = 'اليوم';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // أقصى اليمين أو البداية: زر "كل المباريات"
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios, color: Colors.amber, size: 12),
              label: const Text(
                'كل المباريات',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),

            // في المنتصف: تبويبات (أمس، اليوم، غداً)
            Row(
              children: [
                _buildDayTab('أمس'),
                const SizedBox(width: 8),
                _buildDayTab('اليوم', isSelected: true),
                const SizedBox(width: 8),
                _buildDayTab('غداً'),
              ],
            ),

            // مساحة فارغة لتوازن التصميم من اليسار
            const SizedBox(width: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTab(String day, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: selectedDay == day ? Colors.amber : Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: selectedDay == day ? Colors.black87 : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}