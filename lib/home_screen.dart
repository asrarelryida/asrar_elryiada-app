import 'package:flutter/material.dart';
import 'widgets/app_header.dart';
import 'widgets/matches_tabs_banner.dart';
import 'widgets/matches_ticker_widget.dart';
import 'widgets/news_section_center.dart'; // شبكة الأخبار على طريقة في الجول
import 'widgets/matches_and_sections_body.dart'; // قسم المباريات والأقسام الإضافية الجديد
import 'login_screen.dart';
import 'widgets/teams_ticker_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        color: const Color(0xFF1A1A1A),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // أقصى اليمين: حقوق النشر
            const Text(
              'جميع الحقوق محفوظة © أسرار الرياضة 2026',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            
            // في المنتصف: البريد الإلكتروني الرسمي للتواصل
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.email_outlined, color: Colors.white70, size: 14),
                SizedBox(width: 6),
                SelectableText(
                  'asrarelryida@gmail.com',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // أقصى اليسار: زر دخول الإدارة
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.admin_panel_settings, color: Colors.white38, size: 12),
              label: const Text(
                'دخول الإدارة',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // الشريط العلوي للموقع (الهيدر واللوجو والأقسام)
              const AppHeader(),
              
              // بانر تبويبات المباريات (أمس، اليوم، غداً)
              const MatchesTabsBanner(),
              
              // شريط المباريات المتحرك
              const MatchesTickerWidget(),
              
              const SizedBox(height: 10),

              // شريط الأندية الجديد
              const TeamsTickerWidget(),
              
              const SizedBox(height: 20),

              // مساحة واسعة ومريحة لشبكة الأخبار الرئيسية والسلايدر
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1050),
                    child: Column(
                      children: const [
                        // شبكة الأخبار والسلايدر (بارتفاع متناسق تماماً وبدون فراغات بيضاء)
                        NewsSectionCenter(),
                        SizedBox(height: 24),
                        // قسم المباريات والأقسام الإضافية
                        MatchesAndSectionsBody(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}