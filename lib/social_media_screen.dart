import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/app_header.dart'; // استيراد الهيدر الموحد للموقع

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          // الهيدر الموحد الفخم للموقع (باللوجو، الوقت، والأقسام)
          const AppHeader(),
          
          // محتوى الصفحة بالكامل داخل Expanded ليكون قابلاً للتمرير
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // البانر الرئيسي للقسم
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB71C1C), Colors.black87],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.forum, size: 60, color: Colors.white),
                        SizedBox(height: 15),
                        Text(
                          'ما يقال على السوشيال ميديا ونرد عليه',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'رصد دقيق لأبرز ما يتداوله الجماهير والنقاد، مع الرد الرسمي والتحليل من موقع أسرار الرياضة',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // جلب البيانات مباشرة من Firebase Firestore
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('social_posts')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(color: Color(0xFFB71C1C)),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              'لا توجد منشورات أو ردود مضافة حتى الآن. ابدئي بإضافتها من لوحة التحكم!',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final posts = snapshot.data!.docs;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            var postData = posts[index].data() as Map<String, dynamic>;
                            String platform = postData['platform'] ?? 'منصة رقمية';
                            String user = postData['user'] ?? 'متابع رياضي';
                            String postText = postData['post'] ?? '';
                            String replyText = postData['reply'] ?? '';
                            String youtubeUrl = postData['youtubeUrl'] ?? '';
                            String time = postData['time'] ?? 'منذ قليل';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // رأس المنصة والوقت
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Chip(
                                          label: Text(platform, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                          backgroundColor: const Color(0xFFB71C1C),
                                        ),
                                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // اسم المستخدم وما قال
                                    Text(
                                      user,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '"$postText"',
                                      style: const TextStyle(color: Colors.black87, fontSize: 15, fontStyle: FontStyle.italic),
                                    ),
                                    
                                    // عرض زر أو إشعار اليوتيوب إذا كان الرابط موجوداً
                                    if (youtubeUrl.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.red.shade200),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.play_circle_fill, color: Colors.red, size: 24),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'فيديو متعلق بالرد: $youtubeUrl',
                                                style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    const Divider(height: 24),
                                    // رد الموقع
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F6F9),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.reply, color: Color(0xFFB71C1C), size: 20),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'أسرار الرياضة ترد: $replyText',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}