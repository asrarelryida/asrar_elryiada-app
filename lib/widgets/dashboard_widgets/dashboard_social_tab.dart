import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد فايربيز

class DashboardSocialTab extends StatefulWidget {
  const DashboardSocialTab({super.key});

  @override
  State<DashboardSocialTab> createState() => _DashboardSocialTabState();
}

class _DashboardSocialTabState extends State<DashboardSocialTab> {
  final _platformController = TextEditingController();
  final _userController = TextEditingController();
  final _postController = TextEditingController();
  final _replyController = TextEditingController();
  final _youtubeController = TextEditingController(); // خانة لينك اليوتيوب الجديدة

  bool _isLoading = false;

  void _submitPost() async {
    if (_platformController.text.isEmpty || _postController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المنصة ومحتوى المنشور على الأقل!'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // حفظ البيانات في مجموعة (Collection) جديدة اسمها social_posts على Firebase
      await FirebaseFirestore.instance.collection('social_posts').add({
        'platform': _platformController.text.trim(),
        'user': _userController.text.trim(),
        'post': _postController.text.trim(),
        'reply': _replyController.text.trim(),
        'youtubeUrl': _youtubeController.text.trim(), // حفظ لينك اليوتيوب
        'time': 'منذ قليل',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // تفريغ الحقول بعد الحفظ الناجح
      _platformController.clear();
      _userController.clear();
      _postController.clear();
      _replyController.clear();
      _youtubeController.clear();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم بنجاح'),
          content: const Text('تم نشر الرد ولينك اليوتيوب في قسم السوشيال ميديا على الموقع!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء النشر: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إدارة قسم السوشيال ميديا والردود',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
          ),
          const SizedBox(height: 8),
          const Text(
            'من هنا يمكنك متابعة ما يقال على منصات التواصل الاجتماعي وكتابة الرد الرسمي مع إدراج لينك فيديو اليوتيوب.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, spreadRadius: 2)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _platformController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المنصة (تويتر/إكس، فيسبوك، انستجرام...)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'اسم صاحب المنشور أو الحساب',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _postController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'ما يقال على السوشيال ميديا (السؤال أو الشائعة)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _replyController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'الرد الرسمي من موقع أسرار الرياضة',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                // حقل لينك يوتيوب الجديد
                TextField(
                  controller: _youtubeController,
                  decoration: const InputDecoration(
                    labelText: 'رابط فيديو اليوتيوب (اختياري)',
                    hintText: 'https://www.youtube.com/watch?v=...',
                    prefixIcon: Icon(Icons.video_library, color: Colors.red),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    _isLoading
                        ? const CircularProgressIndicator(color: Color(0xFFB71C1C))
                        : ElevatedButton(
                            onPressed: _submitPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB71C1C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('نشر في الموقع', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
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