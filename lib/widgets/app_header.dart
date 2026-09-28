import 'dart:async';
import 'package:flutter/material.dart';
import '../category_news_screen.dart';
import '../about_screen.dart';
import '../home_screen.dart';
import '../social_media_screen.dart'; // استيراد صفحة السوشيال ميديا الجديدة

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  late String _timeString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _timeString = _formatCurrentTime();
      });
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    const days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];

    String dayName = days[now.weekday - 1];
    String monthName = months[now.month - 1];
    
    int hour = now.hour;
    String period = 'ص';
    if (hour >= 12) {
      period = 'م';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;

    String minute = now.minute.toString().padLeft(2, '0');
    String second = now.second.toString().padLeft(2, '0');

    return '$dayName، ${now.day} $monthName ${now.year} | $hour:$minute:$second $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      color: const Color(0xFFB71C1C), // أحمر داكن فخم
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // أقصى اليمين: اللوجو والأقسام الاحترافية
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const AboutScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 65,
                          child: Image.asset(
                            'assets/images/logo/ASRARELRYIDA LOGO.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'أسرار الرياضة',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // الأقسام الأساسية
                _buildHomeItem(context, 'الرئيسية'),
                _buildNavItem(context, 'مصر'),
                _buildNavItem(context, 'عالمي'),
                _buildNavItem(context, 'المحترفون', isHighlight: true),
                _buildNavItem(context, 'الدوري المصري'),
                _buildNavItem(context, 'مقالات'),
                _buildNavItem(context, 'مباريات'),
                _buildNavItem(context, 'ألعاب أخرى'),
                _buildNavItem(context, 'فيديوهات وصور'),
                // زر قسم السوشيال ميديا الجديد
                _buildSocialMediaTab(context),
              ],
            ),

            // أقصى اليسار: الوقت وأيقونات السوشيال
            Row(
              children: [
                Text(
                  _timeString,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
                const SizedBox(width: 6),
                _buildSocialIcon('يوتيوب', Icons.video_library),
                _buildSocialIcon('انستجرام', Icons.camera_alt),
                _buildSocialIcon('X', Icons.close),
                _buildSocialIcon('تيك توك', Icons.music_note),
                _buildSocialIcon('واتساب', Icons.chat),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeItem(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, {bool isHighlight = false}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => CategoryNewsScreen(categoryName: title),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
            transitionDuration: Duration.zero,
          ),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          title,
          style: TextStyle(
            color: isHighlight ? Colors.amberAccent : Colors.white,
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // دالة زر السوشيال ميديا في الهيدر
  Widget _buildSocialMediaTab(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SocialMediaScreen()),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: const [
            Icon(Icons.forum, color: Colors.amberAccent, size: 16),
            SizedBox(width: 4),
            Text(
              'سوشيال ميديا',
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String tooltip, IconData icon) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}