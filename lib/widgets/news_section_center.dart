import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_news_slider.dart';
import 'app_header.dart'; // الهيدر الأساسي للموقع باللوجو والأقسام
import 'breaking_news_ticker.dart'; // ملف شريط الأخبار العاجلة المستقل
import 'dart:convert';

class NewsSectionCenter extends StatefulWidget {
  const NewsSectionCenter({super.key});

  @override
  State<NewsSectionCenter> createState() => _NewsSectionCenterState();
}

class _NewsSectionCenterState extends State<NewsSectionCenter> {
  // دالة موحدة لفتح تفاصيل الخبر تعرض الهيدر الأساسي واللوجو والتفاصيل مرتبة يميناً
  void _openNewsDetails(BuildContext context, Map<String, dynamic> newsData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F6F9),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(),
                  const SizedBox(height: 24),

                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 850),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFB71C1C)),
                                label: const Text(
                                  'الرئيسية',
                                  style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB71C1C).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      newsData['category'] ?? 'أخبار عامة',
                                      style: const TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  Text(
                                    newsData['title'] ?? 'بدون عنوان',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      height: 1.4,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 16, color: Color(0xFFB71C1C)),
                                          const SizedBox(width: 6),
                                          Text(
                                            'الكاتب: ${newsData['author'] ?? 'أسرار الرياضة'}',
                                            style: const TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.w600, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        newsData['dateTime'] ?? '',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 32),

                                  if (newsData['imageUrl'] != null || newsData['image'] != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: _buildNewsImage(newsData['imageUrl'] ?? newsData['image']),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 28),

                                  Text(
                                    newsData['content'] ?? newsData['description'] ?? 'لا يوجد محتوى تفصيلي مضاف لهذا الخبر حتى الآن.',
                                    style: const TextStyle(
                                      fontSize: 16.5,
                                      height: 1.9,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('news').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 364);
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('لا توجد أخبار منشورة حالياً.', style: TextStyle(color: Colors.grey)),
          );
        }

        final newsDocs = snapshot.data!.docs;
        
        final sliderNewsList = newsDocs.take(10).map((doc) => doc.data() as Map<String, dynamic>).toList();
        final subNews = newsDocs.skip(1).take(4).toList();
        
        final titlesList = newsDocs.map((doc) => (doc.data() as Map<String, dynamic>)['title'] ?? '').toList().cast<String>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BreakingNewsTicker(titles: titlesList),

              Container(
                height: 364,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: subNews.map((doc) {
                          final newsData = doc.data() as Map<String, dynamic>;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: InkWell(
                                onTap: () => _openNewsDetails(context, newsData),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                        child: SizedBox(
                                          width: 100,
                                          height: double.infinity,
                                          child: _buildNewsImage(newsData['imageUrl'] ?? newsData['image']),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                newsData['category'] ?? 'أخبار',
                                                style: const TextStyle(fontSize: 10, color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                newsData['title'] ?? 'بدون عنوان',
                                                style: const TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                  height: 1.2,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: 364,
                        child: MainNewsSlider(
                          sliderNewsList: sliderNewsList,
                          onNewsTap: _openNewsDetails,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsImage(dynamic img) {
    String url = (img ?? '').toString().trim();
    
    if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _errorImagePlaceholder(),
        );
      } catch (_) {}
    }

    if (url.isNotEmpty && url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImagePlaceholder(),
      );
    }
    
    return _errorImagePlaceholder();
  }

  Widget _errorImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.article, color: Color(0xFFB71C1C), size: 30),
    );
  }
}