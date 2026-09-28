import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'app_header.dart'; // الهيدر الأساسي للموقع باللوجو والأقسام

class MatchesAndSectionsBody extends StatelessWidget {
  const MatchesAndSectionsBody({super.key});

  // دالة موحدة لفتح تفاصيل الخبر بشكل مستقر وسريع
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
                                  
                                  // إذا وُجد رابط خبر متعلق (Feedback Link)، يظهر بشكل جذاب في نهاية المقال
                                  if (newsData['feedbackLink'] != null && newsData['feedbackLink'].toString().isNotEmpty) ...[
                                    const SizedBox(height: 24),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.link, color: Color(0xFFB71C1C)),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'خبر متعلق: ${newsData['feedbackLink']}',
                                              style: const TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  // صفحة أرشيف القسم عند الضغط على "المزيد"
  void _openCategoryPage(BuildContext context, String categoryName, List<QueryDocumentSnapshot> categoryNews) {
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
                      constraints: const BoxConstraints(maxWidth: 1050),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'أرشيف قسم: $categoryName',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                                ),
                                TextButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFB71C1C)),
                                  label: const Text('الرئيسية', style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.7,
                              ),
                              itemCount: categoryNews.length,
                              itemBuilder: (context, index) {
                                final news = categoryNews[index].data() as Map<String, dynamic>;
                                return InkWell(
                                  onTap: () => _openNewsDetails(context, news),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        _buildNewsImage(news['imageUrl'] ?? news['image']),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.85),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                            child: Text(
                                              news['title'] ?? 'بدون عنوان',
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
    final List<String> mainCategories = [
      'المحترفون',
      'عالمي',
      'مصر',
      'الدوري المصري',
      'مقالات',
      'ألعاب أخرى',
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('news').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('لا توجد أقسام أو أخبار مضافة حالياً.', style: TextStyle(color: Colors.grey)),
                );
              }

              final allDocs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mainCategories.length,
                itemBuilder: (context, catIndex) {
                  String categoryName = mainCategories[catIndex];
                  
                  final categoryNews = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    String docCategory = (data['category'] ?? '').toString().trim();
                    return docCategory == categoryName;
                  }).toList();

                  if (categoryNews.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final displayNews = categoryNews.take(3).toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 18,
                                  color: const Color(0xFFB71C1C),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  categoryName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => _openCategoryPage(context, categoryName, categoryNews),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text(
                                  'المزيد ←',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 14),
                        const SizedBox(height: 8),
                        
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: displayNews.map((doc) {
                            final news = doc.data() as Map<String, dynamic>;
                            return SizedBox(
                              width: 320,
                              height: 180,
                              child: InkWell(
                                onTap: () => _openNewsDetails(context, news),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      _buildNewsImage(news['imageUrl'] ?? news['image']),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.85),
                                                Colors.black.withOpacity(0.4),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Text(
                                            news['title'] ?? 'بدون عنوان',
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1.25,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
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
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _errorImagePlaceholder(),
        );
      } catch (_) {}
    }

    if (url.isNotEmpty && url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _errorImagePlaceholder(),
      );
    }
    
    return _errorImagePlaceholder();
  }

  Widget _errorImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.article, color: Color(0xFFB71C1C), size: 30),
      ),
    );
  }
}