import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن الموقع'),
        backgroundColor: const Color(0xFFB71C1C),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كارت بلون داكن فخم يبرز اللوجو ويوضح هويته تماماً
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFB71C1C).withOpacity(0.5), width: 1.5),
                  ),
                  child: Image.asset(
                    'assets/images/logo/ASRARELRYIDA LOGO.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'موقع أسرار الرياضة',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'وجهتك الأولى لكل ما هو جديد في عالم الرياضة المحلية والعالمية',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(height: 40, thickness: 1),
              const Text(
                'من نحن؟',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'موقع "أسرار الرياضة" هو منصة رياضية رقمية متكاملة تهدف إلى تقديم تغطية حصرية، تحليلية، وفورية لأبرز الأحداث الرياضية في مصر والعالم العربي والعالم. نحن نسعى لنقل الحقيقة الرياضية بكل حيادية وموضوعية، مع التركيز على كواليس وأسرار الملاعب التي تشغل بال الجمهور.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 20),
              const Text(
                'رؤيتنا وأهدافنا',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '• تقديم محتوى رياضي احترافي ومبتكر يواكب تطلعات المشجع العربي.\n'
                '• تغطية لحظية للمباريات، والنتائج، والترتيبات عبر قواعد بيانات حديثة.\n'
                '• خلق مجتمع تفاعلي لعشاق الكرة والرياضات المختلفة.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 30),
              
              // قسم التواصل عبر الإيميل الرسمي
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email, color: Color(0xFFB71C1C), size: 28),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تواصل معنا ورعاية الموقع:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          'asrarelryida@gmail.com',
                          style: TextStyle(color: Colors.blue.shade800, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}