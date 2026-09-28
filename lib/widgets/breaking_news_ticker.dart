import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class BreakingNewsTicker extends StatelessWidget {
  final List<String> titles;

  const BreakingNewsTicker({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    if (titles.isEmpty) {
      return const SizedBox.shrink();
    }

    // أخذ أحدث 8 أخبار فقط لضمان التركيز وسلاسة الشريط
    final latestTitles = titles.length > 8 
        ? titles.sublist(0, 8) 
        : titles;

    final breakingText = latestTitles.join('    •    ');

    return Container(
      height: 40,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xFFB71C1C),
            alignment: Alignment.center,
            child: const Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'عاجل',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Marquee(
                text: '$breakingText    •    ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 100.0,
                velocity: 40.0, // يمكنك تقليل هذا الرقم (مثلاً إلى 30) إذا أردت سرعة أبطأ
                pauseAfterRound: Duration.zero,
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                decelerationDuration: const Duration(milliseconds: 500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}